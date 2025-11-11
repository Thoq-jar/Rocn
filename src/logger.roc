module [info!, success!, warn!, error!, debug!]

import pf.Stdout

cyan = "\u(001b)[36m"
green = "\u(001b)[32m"
yellow = "\u(001b)[33m"
red = "\u(001b)[31m"
magenta = "\u(001b)[35m"
bold = "\u(001b)[1m"
reset = "\u(001b)[0m"

info! : Str => Result {} _
info! = \message ->
    Stdout.line!("$(cyan)$(bold)ℹ INFO:$(reset) $(cyan)$(message)$(reset)")?
    Ok {}

success! : Str => Result {} _
success! = \message ->
    Stdout.line!("$(green)$(bold)✓ SUCCESS:$(reset) $(green)$(message)$(reset)")?
    Ok {}

warn! : Str => Result {} _
warn! = \message ->
    Stdout.line!("$(yellow)$(bold)⚠ WARNING:$(reset) $(yellow)$(message)$(reset)")?
    Ok {}

error! : Str => Result {} _
error! = \message ->
    Stdout.line!("$(red)$(bold)✗ ERROR:$(reset) $(red)$(message)$(reset)")?
    Ok {}

debug! : Str => Result {} _
debug! = \message ->
    Stdout.line!("$(magenta)$(bold)? DEBUG:$(reset) $(magenta)$(message)$(reset)")?
    Ok {}

