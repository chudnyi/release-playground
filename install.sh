#!/bin/sh
set -e

if ! command -v unzip >/dev/null && ! command -v 7z >/dev/null; then
	echo "Error: either unzip or 7z is required to install." 1>&2
	exit 1
fi

if [ "$OS" = "Windows_NT" ]; then
#	target="x86_64-pc-windows-msvc"
  echo "Error: Windows is not supported yet." 1>&2
  exit 1
else
	case $(uname -sm) in
	"Darwin x86_64") target="x86_64-apple-darwin" ;;
	"Darwin arm64") target="aarch64-apple-darwin" ;;
	"Linux aarch64") target="aarch64-unknown-linux-gnu" ;;
	*) target="x86_64-unknown-linux-gnu" ;;
	esac
fi

if [ $# -eq 0 ]; then
	play_uri="https://github.com/chudnyi/release-playground/releases/latest/download/play-${target}.zip"
else
	play_uri="https://github.com/chudnyi/release-playground/releases/download/${1}/play-${target}.zip"
fi

play_install="${PLAY_DIR:-$HOME/.play}"
bin_dir="$play_install/bin"
exe="$bin_dir/play"

if [ ! -d "$bin_dir" ]; then
	mkdir -p "$bin_dir"
fi

curl --fail --location --progress-bar --output "$exe.zip" "$play_uri"
if command -v unzip >/dev/null; then
	unzip -d "$bin_dir" -o "$exe.zip"
else
	7z x -o"$bin_dir" -y "$exe.zip"
fi
mv "$exe-$target" "$exe"
chmod +x "$exe"
rm "$exe.zip"

echo "Play was installed successfully to $exe"
if command -v play >/dev/null; then
	echo "Run 'play --help' to get started"
else
	case $SHELL in
	/bin/zsh) shell_profile=".zshrc" ;;
	*) shell_profile=".bashrc" ;;
	esac
	echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
	echo "  export PLAY_DIR=\"$play_install\""
	echo "  export PATH=\"\$PLAY_DIR/bin:\$PATH\""
	echo "Run '$exe --help' to get started"
fi
echo
#echo "Stuck? Join our Discord https://discord.gg/play"
