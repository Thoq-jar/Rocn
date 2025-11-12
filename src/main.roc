app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br" }

import pf.Path
import pf.Dir
import pf.Arg
import pf.File
import Config
import Fs
import Logger
import Command

file_path = Path.from_str("build.rocn")
rocn_dir = ".rocn"
exe = "roc"
version = "0.1.0"
help_message = "Available commands: build, run, check, clean, format, repl, version, help"

main! = |args|
    Logger.info!("Rocn starting...")?
    strArgs = args |> List.drop_first(1) |> List.map(Arg.display)

    command =
        when List.get(strArgs, 0) is
            Ok cmd -> cmd
            Err _ -> "build"

    _ =
        if command == "init" then
            Logger.info!("Initializing new Rocn project...")?

            build_config_content = "source  src\nfile    main.roc\n"
            Logger.info!("Creating build.rocn at: ${Path.display file_path}")?
            File.write_utf8!(build_config_content, Path.display(file_path))?

            Logger.info!("Created build.rocn")?

            Logger.info!("Creating src directory at: ${Path.display (Path.from_str "src")}")?
            Dir.create_all!("src")?
            Logger.info!("Created src directory")?

            main_roc_content =
                """
                app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br" }

                import pf.Stdout

                main! = |_args|
                    Stdout.line!("Hello, World!")
                """
            Logger.info!("Creating src/main.roc at: ${Path.display (Path.from_str "src/main.roc")}")?
            File.write_utf8!(main_roc_content, "src/main.roc")?

            Logger.info!("Created src/main.roc")?
            Logger.info!("Project initialized successfully!")?

            Ok {}
        else
            file_contents =
                when Fs.read_file!(Path.display(file_path)) is
                    Ok contents -> Ok contents
                    Err _ -> Err (FileError "failed to read file")

            build_config =
                when Config.parse_build_config(file_contents?) is
                    Ok config -> config
                    Err _ -> { source: "", file: "" }

            Dir.create_all!(rocn_dir)?
            Dir.create_all!("${rocn_dir}/build")?

            main_path = "${build_config.source}/${build_config.file}"
            old_exe_path = "${build_config.source}/main"
            exe_path = "${rocn_dir}/build/main"

            when command is
                "build" ->
                    Logger.info!("Building project...")?
                    Command.system!("${exe} build ${main_path}")?
                    Fs.move_file!(old_exe_path, exe_path)?

                    Logger.info!("Build complete.")?
                    Ok {}

                "run" ->
                    Logger.info!("Building and running project...")?
                    Command.system!("${exe} build ${main_path}")?
                    Fs.move_file!(old_exe_path, exe_path)?

                    Logger.info!("Running...")?
                    Command.system!(exe_path)?
                    Ok {}

                "check" ->
                    Logger.info!("Checking project...")?
                    Command.system!("${exe} check ${main_path}")?
                    Logger.info!("Check complete.")?
                    Ok {}

                "clean" ->
                    Logger.info!("Cleaning build directory...")?
                    Dir.delete_all!("${rocn_dir}/build")?

                    Logger.info!("Clean complete.")?
                    Ok {}

                "version" ->
                    Logger.info!("Rocn Build System v${version}")?
                    Ok {}

                "format" ->
                    Logger.info!("Formatting codebase...")?
                    Command.system!("${exe} format")?
                    Ok {}

                "help" ->
                    Logger.info!(help_message)?
                    Ok {}

                "repl" ->
                    Command.system!("roc repl")?
                    Ok {}

                _ ->
                    Logger.error!("Unknown command: ${command}")?
                    Logger.info!(help_message)?
                    Err UnknownCommand

    Logger.info!("Done.")?
    Ok {}

