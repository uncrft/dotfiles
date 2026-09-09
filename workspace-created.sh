#!/bin/sh

set -eu

: "${HERDR_WORKSPACE_ID:?missing workspace ID}"
: "${HERDR_TAB_ID:?missing tab ID}"
: "${HERDR_PANE_ID:?missing pane ID}"

case ${HERDR_PLUGIN_EVENT_JSON:-} in
  *'"label":"__rift__:'*) exit 0 ;;
esac

herdr=${HERDR_BIN_PATH:-herdr}

"$herdr" tab rename "$HERDR_TAB_ID" agent >/dev/null

code_tab=$(
  "$herdr" tab create \
    --workspace "$HERDR_WORKSPACE_ID" \
    --label code \
    --no-focus
)

case $code_tab in
  *'"pane_id":"'*)
    code_pane=${code_tab#*'"pane_id":"'}
    code_pane=${code_pane%%'"'*}
    ;;
  *)
    printf 'could not find code pane ID in response:\n%s\n' "$code_tab" >&2
    exit 1
    ;;
esac

"$herdr" tab create \
  --workspace "$HERDR_WORKSPACE_ID" \
  --label terminal \
  --no-focus \
  >/dev/null

"$herdr" pane wait-output \
  "$code_pane" \
  --match '❯' \
  --source visible \
  --timeout 10000 \
  >/dev/null
sleep 1
"$herdr" pane send-text "$code_pane" nvim >/dev/null
"$herdr" pane send-keys "$code_pane" enter >/dev/null

"$herdr" pane run "$HERDR_PANE_ID" fx >/dev/null
