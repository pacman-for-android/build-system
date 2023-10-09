perl -pi -e 's/(usr(?=\/))|((?<=\/)usr)/data\/usr/g' "$1"
perl -pi -e 's/(etc(?=\/))|((?<=\/)etc)/data\/etc/g' "$1"
