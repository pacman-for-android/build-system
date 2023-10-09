set -e

_PFA_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_PFA_SOURCE_DIR="$_PFA_SCRIPT_DIR/../sources"

cd "$_PFA_SCRIPT_DIR/../patches/$(basename "$(dirname "$1")")"

if [[ -f preprepare ]] || [[ -f postprepare ]]; then
    echo "Found prepare hooks!"
else
    echo "No prepare hooks found!"
    exit 0
fi

sed -e '/@@_pfa_preprepare@@/{
    s/@@_pfa_preprepare@@//g
    r preprepare
}' -e '/@@_pfa_postprepare@@/{
    s/@@_pfa_postprepare@@//g
    r postprepare
}' "$_PFA_SCRIPT_DIR/prepare-hook.snippet" >> "$1"
