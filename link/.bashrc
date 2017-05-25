# Add binaries into the path
PATH=~/.dotfiles/bin:~/bin:/usr/local/sbin:~/.chefdk/gem/ruby/2.3.0/bin:$PATH
export PATH

# Source all files in ~/.dotfiles/source/
function src() {
  local file
  if [[ "$1" ]]; then
    source "$HOME/.dotfiles/source/$1.sh"
  else
    for file in ~/.dotfiles/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  ~/.dotfiles/bin/dotfiles "$@" && src
}

src

PERL_MB_OPT="--install_base \"/Users/mglover/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/mglover/perl5"; export PERL_MM_OPT;
