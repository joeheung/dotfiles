#!/bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bin="/usr/local/bin"

link() {
  from="$1"
  to="$2"
  echo "Linking '$to' -> '$from'"
  rm -f $to
  ln -s "$from" "$to"
}

for location in home/*; do
  file="${location##*/}"
  file="${file%.*}"
  link "$dotfiles/$location" "$HOME/.$file"
done

for location in bin/*; do
  file="${location##*/}"
  file="${file%.*}"
  if [ -x "$dotfiles/$location" ]; then
    link "$dotfiles/$location" "$bin/$file"
  fi
done

link "$dotfiles/completion/" "$HOME/.completion"


# Install OS specific stuff
OS=$(uname -s)
[[ $OS = "Darwin" ]] && $dotfiles/install/osx.sh
[[ $OS = "Linux" ]] && $dotfiles/install/linux.sh

unset link
