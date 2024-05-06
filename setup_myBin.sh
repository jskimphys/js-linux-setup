# --------------------- inside HOME --------------------
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh}/plugins/zsh-syntax-highlighting

#copy .zshrc
cp $HOME/.zshrc $HOME/.zshrc.bak
cp .zshrc $HOME/.zshrc

#copy .config/nvim
if [ ! -d $HOME/.config ]; then
  mkdir -p $HOME/.config
fi
git clone git@github.com:jskimphys/myNvim.git $HOME/.config/nvim

# ---------------- inside myBin ----------------
if [ ! -d $HOME/myBin ]; then
  mkdir $HOME/myBin
fi
cd $HOME/myBin
MYBIN=$HOME/myBin

if [! -d $MYBIN/bat]; then
  curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  tar -zxf bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  ln -s bat-v0.24.0-x86_64-unknown-linux-gnu/bat bat
fi

if [! -d $MYBIN/node-v20.12.2-linux-x64]; then
  curl -LO https://nodejs.org/dist/v20.12.2/node-v20.12.2-linux-x64.tar.xz
  tar xf node-v20.12.2-linux-x64.tar.xz
  ln -s node-v20.12.2-linux-x64/bin/node node
fi

if [! -d $MYBIN/nvim-linux64]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  tar -zxf nvim-linux64.tar.gz
  ln -s nvim-linux64/bin/nvim nvim
fi

if [! -d $MYBIN/fzf-git.sh]; then
  git clone https://github.com/junegunn/fzf-git.sh.git
fi


if [! -d $MYBIN/ripgrep]; then
  git clone https://github.com/BurntSushi/ripgrep
  cd ripgrep
  cargo build --release
  ./target/release/rg --version
  ln -s target/release/rg rg
fi

rm *.tar.gz
rm *.tar.xz
# ----------------------------------------------

cd $HOME
