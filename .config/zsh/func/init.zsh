# Declares load functions
funcs=(
  shellbenchmark
)

for func in $funcs; do
  source $__FUNCDIR/$func.sh
done
