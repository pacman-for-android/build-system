SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat "$SCRIPT_DIR/shebang-fixup.snippet" >> "$1"