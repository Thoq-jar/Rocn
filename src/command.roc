module [system!]

import pf.Cmd
import Logger

RocnError : [
    CommandError Str,
    FileError Str,
    DirError Str,
    UnknownCommand,
]

system! : Str => Result {} RocnError
system! = |cmd|
    _ = Logger.info!("Running: ${cmd}")

    when Cmd.exec!("sh", ["-c", cmd]) is
        Ok _ -> Ok {}
        Err err ->
            err_str =
                when err is
                    ExecFailed { command, exit_code } ->
                        "Command `${command}` failed with exit code ${exit_code |> Num.to_str}"

                    FailedToGetExitCode { command, err: _ } ->
                        "Failed to get exit code for command `${command}`"

                    StdoutErr _ -> "Stdout error"
                    DirError _ -> "Directory error"
                    Exit _ str -> "Exited: ${str}"

            Err (CommandError err_str)

