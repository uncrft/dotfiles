def --env drift [query?: string] {
    let ancestors_result = (do { ^rift ancestors } | complete)
    if $ancestors_result.exit_code != 0 {
        print --stderr "drift: not a rift workspace (or any of the parent directories)"
        ^false
        return
    }

    let ancestors = ($ancestors_result.stdout | lines)
    let root = if ($ancestors | is-empty) { $env.PWD } else { $ancestors | last }
    let root_name = ($root | path basename)

    let root_label = ([$root_name "(root)"] | str join " ")
    mut pending = [{ path: $root, label: $root_label }]
    mut rifts = []

    while not ($pending | is-empty) {
        let current = ($pending | first)
        $pending = ($pending | skip 1)
        $rifts = ($rifts | append $current)

        let list_result = (do { ^rift list $current.path } | complete)
        if $list_result.exit_code != 0 {
            let message = ($list_result.stderr | str trim)
            print --stderr (if ($message | is-empty) { "drift: unable to list rift workspaces" } else { $message })
            ^false
            return
        }

        for child in ($list_result.stdout | lines | where { |path| ($path | str trim) != "" }) {
            let child_name = ($child | path basename)
            let child_label = if $current.path == $root {
                $child_name
            } else {
                $"($current.label) → ($child_name)"
            }
            $pending = ($pending | append {
                path: $child
                label: $child_label
            })
        }
    }

    let max_label_length = ($rifts | get label | each { str length } | math max)
    let entries = ($rifts
        | each { |rift|
            let padding = ($max_label_length - ($rift.label | str length))
            $"($rift.label)('' | fill -c ' ' -w $padding)\t(ansi attr_dimmed)($rift.path)(ansi reset)"
        }
        | str join "\n")

    let fzf_result = if ($query | is-empty) {
        do { $entries | ^fzf --ansi --delimiter="\t" --nth=1 } | complete
    } else {
        do { $entries | ^fzf --ansi --delimiter="\t" --nth=1 --query $query --select-1 --exit-0 } | complete
    }

    if $fzf_result.exit_code == 1 and not ($query | is-empty) {
        print --stderr $"drift: no rift matches '($query)'"
        ^false
        return
    }

    if $fzf_result.exit_code != 0 {
        return
    }

    let selected = ($fzf_result.stdout | str trim)
    if not ($selected | is-empty) {
        cd ($selected | split row "\t" | last | ansi strip | str trim)
    }
}
