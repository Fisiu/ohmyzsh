# zsh theme requires 256 color enabled terminal
# i.e TERM=xterm-256color

R="%{$reset_color%}"

GIT_CHAR="±"
SVN_CHAR="⑆"
HG_CHAR="☿"

CLEAN_CHAR="$FG[002]✓${R}"
DIRTY_CHAR="$FG[001]✗${R}"

SCM_GIT_CHAR="$FG[002]${GIT_CHAR}${R}"
SCM_SVN_CHAR="$FG[014]${SVN_CHAR}${R}"
SCM_HG_CHAR="$FG[166]${HG_CHAR}${R}"

ZSH_THEME_GIT_PROMPT_PREFIX="[${SCM_GIT_CHAR}|"
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY=" $DIRTY_CHAR"
ZSH_THEME_GIT_PROMPT_CLEAN=" $CLEAN_CHAR"

function svn_prompt_info {
    local branch=""
    local repository=""
    local version=""
    local st=""

    if [ -d ".svn" ]; then
        branch=$(LANG=C svn info | grep '^URL:' | egrep -o '((tags|branches)/[^/]+|trunk).*' | sed -E -e 's/^(branches|tags)\///g')
        
        change_count=$(svn status | grep "?\|\!\|M\|A" | wc -l)
        [[ "$change_count" == "0" ]] && st="${CLEAN_CHAR}" || st="${DIRTY_CHAR}"
        
        echo "[${SCM_SVN_CHAR}|${branch} ${st}]"
    fi
}

function hg_prompt_info {
    local root=""
    local branch=""
    local st=""
    
    root=$(hg branch 2> /dev/null)
    if [ $? -eq 0 ]; then
        branch=$(hg branch 2> /dev/null)
        
        change_count=$(hg status | grep "?\|\!\|M\|A" | wc -l)
        [[ "$change_count" == "0" ]] && st="${CLEAN_CHAR}" || st="${DIRTY_CHAR}"

        echo "[$SCM_HG_CHAR|${branch} ${st}]"
    fi
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

ID='$FG[075]%n${R}@$FG[007]%m${R}'
RVM='$FG[161]$(rvm_version_info)${R}'
VENV='$FG[231]$(virtualenv_info)${R}'
SCM='$(git_prompt_info)$(svn_prompt_info)$(hg_prompt_info)'
DIR="${R}:$FG[011]%~${R} $FG[002]\$${R} "

PROMPT="${ID}${RVM}${VENV}${SCM}${DIR}"

