set -e

[ $# -ne 2 ] && echo "Usage: $0 <pkgbase> <pkgrel>" && exit 1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SOURCES_DIR="$SCRIPT_DIR/../sources"
PKGBUILD_PATH="$SOURCES_DIR/$1/PKGBUILD"

source "$PKGBUILD_PATH"

if [ $(vercmp "$pkgrel" "$2") -ne -1 ] && [ -z "$ALLOW_PKGREL_DOWNGRADE" ]; then
  echo "Error: $pkgrel >= $2"
  exit 1
fi

echo "Changing pkgrel from $pkgrel to $2 ..."

setconf "$PKGBUILD_PATH" pkgrel "$2"
