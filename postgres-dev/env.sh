if [ ! -d "$DEVBOX_WD/src" ]; then
  echo "error: '$DEVBOX_WD' does not look like a PostgreSQL source tree (no 'src/' directory)." >&2
  echo "       Please launch this devbox shell from the root of a PostgreSQL checkout." >&2
  exit 1
fi

pg_branchname=$(git -C $DEVBOX_WD rev-parse --abbrev-ref HEAD)
pg_branch=$(echo $pg_branchname | sed -r 's/\//-/g')
pg_build=$DEVBOX_PROJECT_ROOT/build/$pg_branch

hex=$(printf '%s' "$pg_branchname" | md5sum | cut -c1-8)
hash=$((16#$hex))

export PGPORT=$((5000 + (hash % 1000)))
export PGDATA=$DEVBOX_PROJECT_ROOT/data/$pg_branchname
export PG_BUILDDIR=$pg_build
export PG_PREFIX=$pg_build/pgsql
export PATH=$PG_PREFIX/bin:$PATH
