set -e

[ $# -ne 1 ] && echo "Usage: $0 <pkgbase>" && exit 1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SOURCES_DIR="$SCRIPT_DIR/../sources"
PKGBUILD_PATH="$SOURCES_DIR/$1/PKGBUILD"

source "$PKGBUILD_PATH"

if echo "${arch[@]}" | grep -q aarch64; then
    exit 0
elif echo "${arch[@]}" | grep -q x86_64; then
    setconf "$PKGBUILD_PATH" arch '(x86_64 aarch64)'
fi
