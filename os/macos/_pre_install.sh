# -*- mode: sh; eval: (sh-set-shell "bash") -*-
# shellcheck shell=bash
#
# OS :: macOS :: Pre-Installation Requirements
#


# shellcheck source=../../lib/utils.sh
. "${XDG_CONFIG_HOME}/lib/utils.sh"


function main () {

  guard.install && {
    msg.domain "Shell" "Ensure Homebrew exists" && {
      shell.has brew || {
        msg.info "Installing brew"
        /bin/bash -c "printf \"\n\" | $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew update
      }
    }

    msg.domain "Shell" "Ensure a recent version of Bash exists" && {
      brew install bash
    }


    msg.domain "Shell" "Allow Homebrew's Bash as login shell" && {
      local brew_bash_path
      brew_bash_path="$(brew --prefix)/bin/bash"

      # Add the path of the Bash version installed through Homebrew to the list
      # of allowed login shells in the `/etc/shells` file.
      if ! grep "${brew_bash_path}" < /etc/shells &> /dev/null; then
        printf '%s\n' "${brew_bash_path}" | sudo tee -a /etc/shells
      fi

      # Set Brew-installed version of Bash as the default (macOS comes with an
      # outdated version of Bash).
      chsh -s "${brew_bash_path}" &> /dev/null
      msg.result $? "Bash (use latest version)"

    }
  }


}

main "$@"
