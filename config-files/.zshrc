#### zsh-git-prompt : https://github.com/olivierverdier/zsh-git-prompt.git
source ~/zsh-git-prompt/zshrc.sh
GIT_PROMPT_EXECUTABLE='haskell'
ZSH_THEME_GIT_PROMPT_CACHE=1

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
# changement des couleurs pour coller à git status
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%1{✚%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%1{●%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%B%1{↓%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%B%1{↑%}"

PROMPT='%B%m:%30<…<%~%<<%b$(git_super_status) %# '
#####

# Evitons les fork bomb involontaires...
ulimit -u 2000

alias  pbcopy='xclip -i -sel clip'
alias pbpaste='xclip -o -sel clip'
alias    open='xdg-open'
alias      ls='/bin/ls --color -F'
alias    vsc='kstart5 vscodium'
