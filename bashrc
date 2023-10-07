PS1="\[\033[1;31m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;121m\]\h\[$(tput sgr0)\]:\[$(tput sgr0)\]\[\033[38;5;208m\]\W\[$(tput sgr0)\]\\$\[$(tput sgr0)\]"
alias ll='ls -la'
alias gc="gcc -Werror -Wextra -Wall"
alias mm="make && valgrind --leak-check=full ./minishell"
alias c="cd code"
alias vgf="valgrind --leak-check=full $1"