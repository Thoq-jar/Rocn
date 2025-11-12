module [
    create_dir_if_not_exists!,
    read_file!,
]

import pf.Dir
import pf.File

create_dir_if_not_exists! : Str => Result {} _
create_dir_if_not_exists! = |path_str|
    Dir.create_all!(path_str)

read_file! : Str => Result Str _
read_file! = |path|
    File.read_utf8!(path)

