pg_branchname=$(git -C $GIT_CLONE_DIR/postgres rev-parse --abbrev-ref HEAD)
pg_branch=$(echo $pg_branchname | sed -r 's/\//-/g')
pg_build=$DEVBOX_PROJECT_ROOT/build/$pg_branch

hex=$(printf '%s' "$pg_branchname" | md5sum | cut -c1-8)
hash=$((16#$hex))

export PGPORT=$((5000 + (hash % 1000)))
export PGDATA=$DEVBOX_PROJECT_ROOT/data/$pg_branchname
export PG_BUILDDIR=$pg_build
export PG_PREFIX=$pg_build/pgsql
export PATH=$PG_PREFIX/bin:$PATH
