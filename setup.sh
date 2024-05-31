#!/bin/zsh
# --------------------- inside HOME --------------------
# install zsh and oh-my-zsh
# if zsh not installed => error

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
if [ ! -d $HOME/.oh-my-zsh ]; then
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-autosuggestions
fi
if [ ! -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-syntax-highlighting
fi

#copy .config/nvim
if [ ! -d $HOME/.config ]; then
  mkdir -p $HOME/.config
fi
if [ ! -d $HOME/.config/nvim ]; then
  git clone git@github.com:jskimphys/myNvim.git $HOME/.config/nvim
else
  oldDir=$PWD
  cd $HOME/.config/nvim
  git pull
  cd $oldDir
fi

# ---------------- inside myBin ----------------
if [ ! -d $HOME/myBin ]; then
  mkdir $HOME/myBin
fi
cd $HOME/myBin
MYBIN=$HOME/myBin

# bat is a cat clone with syntax highlighting
if [ ! -d $MYBIN/bat-v0.24.0-x86_64-unknown-linux-gnu ]; then
  curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  tar -zxf bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  ln -s bat-v0.24.0-x86_64-unknown-linux-gnu/bat bat
fi

# nodejs is for install other packages
if [ ! -d $MYBIN/node-v20.12.2-linux-x64 ]; then
  curl -LO https://nodejs.org/dist/v20.12.2/node-v20.12.2-linux-x64.tar.xz
  tar xf node-v20.12.2-linux-x64.tar.xz
fi

if [ ! -d $MYBIN/nvim-linux64 ]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  tar -zxf nvim-linux64.tar.gz
  ln -s nvim-linux64/bin/nvim nvim
fi

# fzf is a fuzzy finder
if [ ! -d $MYBIN/fzf_dir ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $MYBIN/fzf_dir
  $MYBIN/fzf_dir/install
  ln -s $MYBIN/fzf_dir/bin/fzf $MYBIN/fzf
  ln -s $MYBIN/fzf_dir/bin/fzf-tmux $MYBIN/fzf-tmux
fi

# fzf-git is a fzf extension for git
if [ ! -d $MYBIN/fzf-git.sh ]; then
  git clone https://github.com/junegunn/fzf-git.sh.git
fi

if [ ! -d $MYBIN/ripgrep ]; then
  git clone https://github.com/BurntSushi/ripgrep
  cd ripgrep
  cargo build --release
  ./target/release/rg --version
  cd MyBin
  ln -s ripgrep/target/release/rg rg
fi

#if temp tar files exist
temp_files="*.tar.gz *.tar.xz"
for file in $temp_files; do
  if [ -f $file ]; then
    rm $file
  fi
done

# ----------------------------------------------
# ----------- now install cargo/npm ------------
# install cargo
if [ ! -d $HOME/.cargo ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
#
source $HOME/.zshrc
npm install tree-sitter-cli
#if no symlink
if [ ! -L $MYBIN/tree-sitter ]; then
  ln -s $MYBIN/node_modules/tree-sitter-cli/tree-sitter $MYBIN/tree-sitter
fi

cargo install fd-find

