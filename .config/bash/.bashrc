# This .bashrc file should be as minimal as possible, dividing up other configurations such as aliases,
# exports and prompts to the .config/bash directory. It can be used to correctly bootstrap a new environment
# that supports it's configs.

# Guard .bashrc from running in the wrong context, only continue if this is an interactive shell. `$-` is a
# special variable that shows the current shell options. If it contains "i", the shell is interactive (started
# by a user). If not, we're in a non-interactive shell (like when running a script). Returning here prevents
# loading prompt, aliases, and other interactive features that could break or slow down scripts.
case $- in
    *i*) ;;
      *) return;;
esac

# Go get the user configs we defined in ~/.config/bash if they exist.
for file in ~/.config/bash/{exports,aliases,prompt}; do
    [ -r "$file" ] && . "$file"
done

# Enable programmable bash completion (tab-completion for commands like git, docker, etc.). Skip if running in
# POSIX mode or if the completion scripts are not installed. On Debian/Ubuntu, the scripts are usually at
# /usr/share/bash-completion or /etc/bash_completion.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
