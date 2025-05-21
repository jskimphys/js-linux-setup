#!/bin/zsh
# --------------------- inside HOME --------------------
# install zsh and oh-my-zsh
# if zsh not installed => error

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [[ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-autosuggestions
fi
if [[ ! -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-syntax-highlighting
fi

#copy .config/nvim
if [[ ! -d $HOME/.config ]]; then
  mkdir -p $HOME/.config
fi
if [[ ! -d $HOME/.config/nvim ]]; then
  git clone https://github.com/jskimphys/myNvim.git $HOME/.config/nvim
  git clone git@github.com:jskimphys/myNvim.git $HOME/.config/nvim
else
  oldDir=$PWD
  cd $HOME/.config/nvim
  git pull
  cd $oldDir
fi

# ---------------- inside myBin ----------------
MYBIN=$HOME/bin
if [[ ! -d $MYBIN ]]; then
  mkdir -p $MYBIN
fi
cd $MYBIN

# ---------------- add myBin to .zshrc PATH -----------------
MYBIN=$HOME/bin

# bat is a `cat` with syntax highlighting
if [[ ! -d $MYBIN/bat-v0.24.0-x86_64-unknown-linux-gnu ]]; then
  curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  tar -zxf bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  ln -s bat-v0.24.0-x86_64-unknown-linux-gnu/bat bat
fi

if [[ ! -d $MYBIN/nvim-linux-x86_64 ]]; then
  wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
  tar -zxf nvim-linux*.tar.gz
  ln -s nvim-linux*/bin/nvim nvim
fi

# fzf is a fuzzy finder
if [[ ! -d $MYBIN/fzf_dir ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $MYBIN/fzf_dir
  $MYBIN/fzf_dir/install
fi
if [[ ! -f $MYBIN/fzf ]]; then
  ln -s $MYBIN/fzf_dir/bin/fzf $MYBIN/fzf
  ln -s $MYBIN/fzf_dir/bin/fzf-tmux $MYBIN/fzf-tmux
fi

# fzf-git is a fzf extension for git
if [[ ! -d $MYBIN/fzf-git.sh ]]; then
  git clone https://github.com/junegunn/fzf-git.sh.git
fi

# lazygit
if [[ ! -d $MYBIN/lazygit_dir ]]; then
  mkdir -p $MYBIN/lazygit_dir
  pushd $MYBIN/lazygit_dir
  wget https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
  tar -zxf lazygit_0.44.1_Linux_x86_64.tar.gz
  rm lazygit_0.44.1_Linux_x86_64.tar.gz
  popd
  ln -s $MYBIN/lazygit_dir/lazygit $MYBIN/lazygit
fi


#if temp tar files exist

if [[ -f *.tar.* ]]; then
  rm *.tar.*
fi

# Define markers as single lines
descrim_start="# >>>>> js-linux-setup managed region start >>>>>"
descrim_end="# <<<<< js-linux-setup managed region end <<<<<"

# Remove any existing managed section
if grep -qF "$descrim_start" $HOME/.zshrc && grep -qF "$descrim_end" $HOME/.zshrc; then
  # back up
  cp $HOME/.zshrc $HOME/.zshrc.bak
  # delete from start marker through end marker (inclusive)
  sed -i "\|$descrim_start|,\|$descrim_end|d" $HOME/.zshrc
fi

# Append new managed section
{
  echo
  echo "$descrim_start"
  echo "export PATH=$MYBIN:\$PATH"
  echo "export EDITOR=nvim"
  echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
  echo 'eval "$(fzf --zsh)"'
  echo
  echo '## ----- use fd instead of fzf -----'
  echo 'export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"'
  echo 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"'
  echo 'export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"'
  echo
  echo '_fzf_compgen_path(){'
  echo '  fd --hidden --exclude .git . "$1"'
  echo '}'
  echo
  echo '_fzf_compgen_dir(){'
  echo '  fd --type=d --hidden --exclude .git . "$1"'
  echo '}'
  echo
  echo '## ----- bat setting -----'
  echo 'export BAT_THEME="Sublime Snazzy"'
  echo "$descrim_end"
} >> $HOME/.zshrc

# reload it
source $HOME/.zshrc

# ---------------- install nodejs ----------------
echo "installing nodejs"
if [[ ! -d $HOME/.nvm ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
source $HOME/.zshrc

# install nodejs
nvm install 22
# Node.js check
node -v 
nvm current 
npm -v 

# nodejs packages
npm install -g tree-sitter-cli
source $HOME/.zshrc

# ----------------------------------------------
# ----------- now install cargo/npm ------------
echo "installing/updating cargo"
if [[ ! -d $HOME/.cargo ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
source $HOME/.zshrc
rustup update

cargo install fd-find
cargo install ripgrep
