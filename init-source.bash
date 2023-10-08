set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SOURCES_DIR="$SCRIPT_DIR/sources"

cd "$SOURCES_DIR"

if [ ! -d "$1" ]; then
  # Clone the repository if it doesn't exist
  git clone "https://gitlab.archlinux.org/archlinux/packaging/packages/$1.git"
  cd "$1"
else
  # Reset and update the repository if it does exist
  cd "$1"
  git reset --hard
  git pull
fi

vcs_rev=$(git describe --tags --exact-match 2> /dev/null || git rev-parse --short HEAD)
echo "VCS revision: $vcs_rev"