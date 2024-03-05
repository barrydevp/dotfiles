# Declares load functions
funcs=(
  shellbenchmark
  fnm
  obsidian
)

for func in $funcs; do
  source $__FUNCDIR/$func.sh
done
