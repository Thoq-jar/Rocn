module [
    create_dir_if_not_exists!,
    move_file!,
    read_file!,
]

import pf.Dir
import pf.File
import pf.Cmd

create_dir_if_not_exists! : Str => Result {} _
create_dir_if_not_exists! = |path_str|
    Dir.create_all!(path_str)

move_file! : Str, Str => Result {} _
move_file! = |source_path, dest_path|
    Cmd.exec!("mv", [source_path, dest_path])?

    Ok {}

read_file! : Str => Result Str _
read_file! = |path|
    File.read_utf8!(path)

