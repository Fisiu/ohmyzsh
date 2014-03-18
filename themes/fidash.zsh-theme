# zsh theme requires 256 color enabled terminal
# i.e TERM=xterm-256color

R="%{$reset_color%}"

GIT_CHAR="±"
SVN_CHAR="⑆"
HG_CHAR="☿"

CLEAN_CHAR="%F{2}✓${R}"
DIRTY_CHAR="%F{1}✗${R}"

SCM_GIT_CHAR="%F{2}${GIT_CHAR}${R}"
SCM_SVN_CHAR="%F{14}${SVN_CHAR}${R}"
SCM_HG_CHAR="%F{F9}${HG_CHAR}${R}"

ZSH_THEME_GIT_PROMPT_PREFIX="[${SCM_GIT_CHAR}|"
ZSH_THEME_GIT_PROMPT_SUFFIX="${R}]"
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

ID="%F{75}%n${R}@%F{7}%m${R}"
SCM='$(git_prompt_info)$(svn_prompt_info)$(hg_prompt_info)'
DIR=":%F{11}%~${R} %F{2}\$${R} "

PROMPT="${ID}${SCM}${DIR}"
