# Declares load functions
funcs=(
  shellbenchmark
  fnm
)

for func in $funcs; do
  source $__FUNCDIR/$func.sh
done
