#!/bin/sh

set -eu

: "${HERDR_WORKSPACE_ID:?missing workspace ID}"
: "${HERDR_TAB_ID:?missing tab ID}"
: "${HERDR_PANE_ID:?missing pane ID}"

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

"$herdr" pane run "$HERDR_PANE_ID" fx >/dev/null
"$herdr" pane run "$code_pane" nvim >/dev/null
