# --------------------- inside HOME --------------------
# install zsh and oh-my-zsh
# if zsh not installed => error

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
if [ ! -d $HOME/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-autosuggestions
fi
if [ ! -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-syntax-highlighting
fi

#copy .zshrc
cp $HOME/.zshrc $HOME/.zshrc.bak
cp zshrc $HOME/.zshrc

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
  ln -s node-v20.12.2-linux-x64/bin/node node
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

#if temp files exist
if [ -f *.tar.gz ]; then
  rm *.tar.gz
fi
if [ -f *.tar.xz ]; then
  rm *.tar.xz
fi
# ----------------------------------------------
# ----------- now install cargo/npm ------------
source $HOME/.zshrc
npm install tree-sitter-cli
#if no symlink
if [ ! -L $HOME/myBin/tree-sitter ]; then
  ln -s $HOME/myBin/node_modules/tree-sitter-cli/tree-sitter $HOME/myBin/tree-sitter
fi

cargo install fd-find

