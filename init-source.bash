set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SOURCES_DIR="$SCRIPT_DIR/sources"

cd "$SOURCES_DIR"

# Check if the PKGBUILD exists in our repository
if [ -f "$SCRIPT_DIR/patches/$1/PKGBUILD" ]; then
  echo "Package '$1' found in our repository."
  rm -rf "$SOURCES_DIR/$1"
  cp -r "$SCRIPT_DIR/patches/$1" "$SOURCES_DIR/"
  exit 0
fi

if [ ! -d "$1" ]; then
  # Clone the repository if it doesn't exist
  git clone "https://gitlab.archlinux.org/archlinux/packaging/packages/$1.git"
  cd "$1"
else
  # Reset and update the repository if it does exist
  cd "$1"
  if [ -d ".git" ]; then
    git reset --hard
    git pull
    git checkout $2
  fi
fi


if [ -d ".git" ]; then
  vcs_rev=$(git describe --tags --exact-match 2> /dev/null || git rev-parse --short HEAD)
  echo "VCS revision: $vcs_rev"
else
  echo "Not in a git repository."
fi