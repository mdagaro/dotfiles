# Add a local un-tracked bashrc if present
if [ -f ${HOME}/.bashrc_local ]; then
    . ${HOME}/.bashrc_local
fi

# Locale settings
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$PATH:~/.local/bin:~/scripts

# Turn off the stupid beeping
set bell-style none

# Show the list of commands if ambiguous anyways
set show-all-if-ambiguous on


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Handy aliases
alias h='history | grep -E'
alias :wq='exit'
alias :q='exit'
alias la='ls -A'
alias ll='la -l'
alias l.='ls -d .*'
alias bashrc=". .bashrc" # Refresh bashrc

# tvim = tmux vim 
alias tvim="vim --servername tmuxEditor --remote"

# Enable base completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# Use the colorized diff if possible
if [ -x /usr/bin/colordiff ]; then
    alias diff=colordiff
fi

# Set up git auto completion. Mainly just used for branches
if [ -f ~/.git-completion.bash  ]; then
    . ~/.git-completion.bash
fi

# Add color shortcuts
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  c_reset=`tput sgr0`
  c_user=`tput setaf 2; tput bold`
  c_path=`tput setaf 4; tput bold`
  c_git_clean=`tput setaf 2`
  c_git_dirty=`tput setaf 1`
  c_git_semidirty=`tput setaf 3`
  c_bold=`tput bold`
fi

# (f)ind by (n)ame
# usage: fn foo
# to find all files/directories containing 'foo' in the name
function fn() {
	if [ $# -eq 2 ]; then
		sudo find $1 -name $2
	elif [ $# -eq 1 ]; then
		find `pwd` -name $1
    else
        echo "(f)ind by (n)ame"
        echo "usage: fn [name]"
        echo "Where name is the file name to search for"
	fi
}

# (f)ind (d)irectory
# usage: fd foo
# to find all directories containing 'foo' in the name
function fd() {
	if [ $# -eq 2 ]; then
		sudo find $1 -type d -name $2
	elif [ $# -eq 1 ]; then
		find `pwd` -type d -name $1
    else
        echo "(f)ind (d)irectory"
        echo "usage: fd [name]"
        echo "Where name is the directory name to search for"
	fi
}

# (f)ind (f)ile
# usage: ff foo
# to find all files containing 'foo' in the name
function ff() {
	if [ $# -eq 2 ]; then
		sudo find $1 -type f -name $2
	elif [ $# -eq 1 ]; then
		find `pwd` -type f -name $1
    else
        echo "(f)ind (f)ile"
        echo "usage: ff [name]"
        echo "Where name is the file name to search for"
	fi
}

# Show the branch if in git directory and choose correct color
git_prompt() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    fi

    git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')

    if git diff --quiet 2>/dev/null >&2; then
        if git diff --staged --quiet 2>/dev/null >&2; then
            git_color="${c_git_clean}"
        else
            git_color="${c_git_semidirty}"
        fi
    else
        git_color=${c_git_dirty}
    fi
    

    echo " -- $git_color$git_branch${c_reset}"
}

# Prompt
PS1="\n╔ \[$c_path\]\w\[$c_reset\]\$(git_prompt)\[$c_reset\]\n╚ \[$c_user\]\h \[$c_reset\](\@) \[$c_user\]\$\[\e[m\] "

# Set up goto auto complete if it exists
if [ -f $HOME/scripts/goto_complete.bash ]; then
    . $HOME/scripts/goto_complete.bash
fi

# Go up 'n' directories
up() {
    local i=$1
    case i in
        ''|*[!0-9]*)
            # Integer
            if [ -z $1 ]; then
                cd ..
            else
                while [ $i -gt 0 ]; do
                    cd ..
                    i=$(($i - 1))
                done
            fi
            ;;
        --help)
            echo "usage: up [n]"
            echo "Go up 'n' directories. If 'n' is not provided go up a single directory."
            ;;
        *)
            echo bad
    esac
}
