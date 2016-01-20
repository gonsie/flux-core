#!/bin/sh
#
#  Automatically build builtin_cmds[] array from builtin/*.c.
#  This script assumes each file exports a single subcommand_<name>_register()
#  function, where <name> is the base filename.
#
cat <<EOF
/* Autogenerated by $(basename $0)
 */
#include <stdlib.h>
#include "builtin.h"

EOF

for f in $@; do
    echo "extern int subcommand_$(basename $f .c)_register (optparse_t *p);"
done

echo
echo "struct builtin_cmd builtin_cmds[] = {"

for f in $@; do
    name=$(basename $f .c)
    fn="subcommand_${name}_register"
    cat <<EOF
    { "$name",
      $fn
    },
EOF
done


cat <<EOF
    { NULL, NULL },
};
EOF

