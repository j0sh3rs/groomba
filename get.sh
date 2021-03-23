#!/bin/sh
set -e
set -x
RELEASES_URL="https://github.com/avbm/groomba/releases"
test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"

last_version() {
  curl -sL -o /dev/null -w %{url_effective} "$RELEASES_URL/latest" |
    rev |
    cut -f1 -d'/'|
    rev
}

download() {
  test -z "$VERSION" && VERSION="$(last_version)"
  test -z "$VERSION" && {
    echo "Unable to get groomba version." >&2
    exit 1
  }
  curl -s -L -o "${TMPDIR}/groomba" \
    "$RELEASES_URL/download/$VERSION/groomba_$(uname -s)_$(uname -m)"
}

download
chmod +x "${TMPDIR}/groomba"
$TMPDIR/groomba
