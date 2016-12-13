# zsh theme requires 256 color enabled terminal
# i.e TERM=xterm-256color
# Set required options
#

R="%{$reset_color%}"

GIT_CHAR="±"
SVN_CHAR="⑆"
HG_CHAR="☿"

CLEAN_CHAR="$FG[002]✓${R}"
DIRTY_CHAR="$FG[001]✗${R}"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$FG[002]%}${GIT_CHAR}${R}|"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" $DIRTY_CHAR"
ZSH_THEME_GIT_PROMPT_CLEAN=" $CLEAN_CHAR"

# Set required options
#
setopt prompt_subst
# Load required modules
#
autoload -Uz vcs_info

# Set vcs_info parameters
#
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' check-for-staged-changes true
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
# zstyle ':vcs_info:git*' formats "[%{$FG[002]%}${GIT_CHAR}${R}|%b%u%c]"
zstyle ':vcs_info:git*' formats "%u%c]"
zstyle ':vcs_info:svn*' formats "[%{$FG[014]%}${SVN_CHAR}${R}|%b%u%c]"
zstyle ':vcs_info:hg*' formats "[%{$FG[166]%}${HG_CHAR}${R}|%b%u%c]"

# zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "

precmd() {
    vcs_info
}

function rvm_version_info {
    local renv=""
    if [ -e ~/.rvm/bin/rvm-prompt ]; then
        renv="$(~/.rvm/bin/rvm-prompt i v g)"
        if [ "$renv" != "" ]; then
            echo "|$renv|"
        fi
    fi
}

function virtualenv_info {
    local venv=""
    if [ -n "$VIRTUAL_ENV" ]; then
        venv=$(basename $VIRTUAL_ENV)
        echo "|$venv|"
    fi
}

function user_mark_info {
    local mark=" $FG[002]$"
    if [[ $UID == 0 || $EUID == 0  ]]; then
        # root
        mark=" $FG[160]#"
    fi
    echo "$mark"
}

ID='$FG[075]%n${R}@$FG[007]%m${R}'
RVM='$FG[161]$(rvm_version_info)${R}'
VENV='$FG[231]$(virtualenv_info)${R}'
GIT='$(git_prompt_info)'
SCM='${vcs_info_msg_0_}'
DIR='${R}:$FG[011]%~${R}'
MARK='$(user_mark_info)${R} '

PROMPT="${ID}${RVM}${VENV}${GIT}${SCM}${DIR}${MARK}"

# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
#
# ------------------------------------------------------------------------------
