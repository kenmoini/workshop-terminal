# Enable kubectl bash completion.

source <(kubectl completion bash)

# Enable oc bash completion.

source <(oc completion bash)

case $- in
  *i*)
    # Interactive session. Try switching to bash.
    if [ -z "$ZSH" ]; then # do nothing if running under bash already
      zsh=$(command -v zsh)
      if [ -x "$zsh" ]; then
        export SHELL="$zsh"
        exec "$zsh" -l
      fi
    fi
esac
