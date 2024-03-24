#!/usr/bin/env bash
set -eo pipefail
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SELF_DIR/.."
source "$SELF_DIR/vars.env"

#  x86_64-unknown-linux-gnu
#  aarch64-unknown-linux-gnu
#  x86_64-pc-windows-msvc
#  x86_64-apple-darwin
#  aarch64-apple-darwin

tests() {
  pkgx "$DENO" test -A "$ROOT_DIR/src"
  pkgx "$DENO" check "$ROOT_DIR/src/cli.ts"
}

build() {
  local target="$1"
  [[ -z "$target" ]] && echo "[ERROR] Required target as first argument: deno compile --help, option: --target" >&2 && exit 1

  pkgx "$DENO" compile -A --output "./dist/play-$target" --target "$target" "$ROOT_DIR/src/cli.ts"
}

macos_codesign() {
  local target="$1"
  [[ -z "$target" ]] && echo "[ERROR] Required target as first argument: deno compile --help, option: --target" >&2 && exit 1

  codesign --sign "$APPLE_IDENTITY" --force \
    --preserve-metadata=entitlements,requirements,flags,runtime "./dist/play-$target" || true
}

archive() {
  local target="$1"
  [[ -z "$target" ]] && echo "[ERROR] Required target as first argument: deno compile --help, option: --target" >&2 && exit 1

  cd ./dist
  zip -r "play-$target.zip" "play-$target"
  rm -fr "play-$target"
}

deploy_release() {
  local target="$1"
  local tag_name="$2"
  [[ -z "$target" ]] && echo "[ERROR] Required target as first argument: deno compile --help, option: --target" >&2 && exit 1
  [[ -z "$tag_name" ]] && echo "[ERROR] Required tag_name as second argument" >&2 && exit 1

  pkgx "$GH" release upload --clobber "$tag_name" "./dist/play-$target.zip"
}

"$@"
