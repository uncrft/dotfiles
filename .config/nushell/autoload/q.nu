# Ask Pi a one-shot question without opening the interactive TUI.
#
# The provider comes from Q_PROVIDER or local q.local.json. Model patterns
# default to haiku, sonnet, and opus. Override them with Q_MODEL, QQ_MODEL,
# and QQQ_MODEL.

def q-config [] {
  let default_path = ($nu.default-config-dir | path join "q.local.json")
  let path = ($env.Q_CONFIG? | default $default_path | path expand)

  if ($path | path exists) {
    try {
      open $path
    } catch {|error|
      error make {
        msg: $"Unable to read Pi question configuration: ($path)"
        help: $error.msg
      }
    }
  } else {
    {}
  }
}

def q-model [configured: any, local: any, fallback: string] {
  let environment_value = ($configured | default "" | into string | str trim)
  let local_value = ($local | default "" | into string | str trim)

  if not ($environment_value | is-empty) {
    $environment_value
  } else if not ($local_value | is-empty) {
    $local_value
  } else {
    $fallback
  }
}

def q-provider-args [args: list<string>, config: record] {
  let has_provider = ($args | any {|arg|
    $arg == "--provider" or ($arg | str starts-with "--provider=")
  })

  if $has_provider {
    return []
  }

  let environment_provider = ($env.Q_PROVIDER? | default "" | str trim)
  let local_provider = ($config | get -o provider | default "" | into string | str trim)
  let provider = if not ($environment_provider | is-empty) {
    $environment_provider
  } else {
    $local_provider
  }

  if ($provider | is-empty) {
    error make {
      msg: "q needs a configured provider"
      help: "Set Q_PROVIDER or add a provider to ~/.config/nushell/q.local.json"
    }
  }

  ["--provider", $provider]
}

def q-run [model: string, args: list<string>, config: record] {
  let input = $in

  if ($args | is-empty) and ($input | is-empty) {
    error make {
      msg: "q needs a question or piped input"
      help: "Try: q \"What does this command do?\" or open README.md | q \"Summarize this\""
    }
  }

  let has_model = ($args | any {|arg|
    $arg == "--model" or ($arg | str starts-with "--model=")
  })
  let model_args = if $has_model { [] } else { ["--model", $model] }
  let pi_args = (q-provider-args $args $config) ++ $model_args ++ $args

  if ($input | is-empty) {
    pi --no-session -p ...$pi_args
  } else {
    $input | pi --no-session -p ...$pi_args
  }
}

def --wrapped q [...args: string] {
  let config = (q-config)
  let model = (q-model $env.Q_MODEL? ($config | get -o models.q) "haiku")
  $in | q-run $model $args $config
}

def --wrapped qq [...args: string] {
  let config = (q-config)
  let model = (q-model $env.QQ_MODEL? ($config | get -o models.qq) "sonnet")
  $in | q-run $model $args $config
}

def --wrapped qqq [...args: string] {
  let config = (q-config)
  let model = (q-model $env.QQQ_MODEL? ($config | get -o models.qqq) "opus")
  $in | q-run $model $args $config
}
