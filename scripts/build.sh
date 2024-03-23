#!/usr/bin/env bash
set -eo pipefail
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SELF_DIR/.."
source "$SELF_DIR/vars.env"

declare -a targets=(
#  x86_64-unknown-linux-gnu
#  aarch64-unknown-linux-gnu
#  x86_64-pc-windows-msvc
#  x86_64-apple-darwin
  aarch64-apple-darwin
)

for target in "${targets[@]}"; do
  output_bin="play-$target"
  output_zip="$output_bin.zip"
  cd "$ROOT_DIR/dist"
  rm -f "$output_bin" "$output_zip"
  pkgx "$DENO" compile -A --output "./$output_bin" --target "$target" "$ROOT_DIR/src/cli.ts"
  pkgx "$SEVENZ" a "$output_zip" "$output_bin"
  rm -f "$output_bin"
done