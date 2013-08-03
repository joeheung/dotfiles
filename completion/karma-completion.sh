###-begin-karma-completion-###
# karma command completion script
# This is stolen from NPM. Thanks @isaac!
#
# Installation: karma completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: karma completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  __karma_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           karma completion -- "${COMP_WORDS[@]}" \
                           2>/var/tmp/karma-completion))
    if [ $? -eq 0 ]; then
      echo "ok" >> "bash.log"
    else
      echo "default" >> "bash.log"
    fi

    IFS="$si"
  }
  complete -o bashdefault -F __karma_completion karma
elif type compdef &>/dev/null; then
  __karma_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 karma completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef __karma_completion karma
elif type compctl &>/dev/null; then
  __karma_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       karma completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K __karma_completion karma
fi
###-end-karma-completion-###