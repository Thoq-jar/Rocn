module [BuildConfig, parse_build_config]

BuildConfig : {
    source : Str,
    file : Str,
}

parse_build_config : Str -> Result BuildConfig [ParseError Str]
parse_build_config = |content|
    lines = Str.split_on(content, "\n")
    source_line = find_line_with_key(lines, "source")
    file_line = find_line_with_key(lines, "file")

    when (source_line, file_line) is
        (Ok source, Ok file) ->
            Ok { source, file }

        _ ->
            Err (ParseError "Missing required fields")

find_line_with_key : List Str, Str -> Result Str [NotFound]
find_line_with_key = |lines, key|
    found =
        lines
        |> List.keep_if(|line| Str.starts_with(line, key))
        |> List.first

    when found is
        Ok line ->
            parts =
                Str.split_on(line, " ")
                |> List.keep_if(|part| part != "")

            when List.get(parts, 1) is
                Ok value -> Ok value
                Err _ -> Err NotFound

        Err _ -> Err NotFound

