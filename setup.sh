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
if [ ! -d $MYBIN ]; then
  mkdir -p $MYBIN
fi
cd $MYBIN

# ---------------- add myBin to .zshrc PATH -----------------
# script managed region descriminator
descrim_start="# >>>>> js-linux-setup managed region start >>>>>\n\
# !!do not edit below this line manually!!"
descrim_end="# <<<<< js-linux-setup managed region end <<<<<"
detect_start=$(grep -n "$descrim_start" $HOME/.zshrc | cut -d: -f1)
detect_end=$(grep -n "$descrim_end" $HOME/.zshrc | cut -d: -f1)

# if descriminator found
if [ -n "$detect_start" ] && [ -n "$detect_end" ]; then
  bak_file=$HOME/.zshrc.bak
  while [ -f $bak_file ]; do # more .bak means more recent
    bak_file=$bak_file.bak
  done
  cp $HOME/.zshrc $bak_file

  sed -i "$detect_start,$detect_end d" $HOME/.zshrc
fi

# add env vars to .zshrc
echo "\n$descrim_start" >> $HOME/.zshrc
echo "export PATH=$MYBIN:\$PATH\n\
export EDITOR=nvim\n\
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh\n\
eval \"\$(fzf --zsh)\"\n\
\n\
## ----- use fd instead of fzf -----\n\
export FZF_DEFAULT_COMMAND=\"fd --hidden --strip-cwd-prefix --exclude .git\"\n\
export FZF_CTRL_T_COMMAND=\"\$FZF_DEFAULT_COMMAND\"\n\
export FZF_ALT_C_COMMAND=\"fd --type=d --hidden --strip-cwd-prefix --exclude .git\"\n\
\n\
_fzf_compgen_path(){\n\
    fd --hidden --exclude .fit . \"\$1\"\n\
}\n\
\n\
_fzf_compgen_dir(){\n\
    fd --type=d --hidden --exclude .git . \"\$1\"\n\
}\n\
\n\
## ----- bat setting -----\n\
export BAT_THEME=\"Sublime Snazzy\"\n"\
  >> $HOME/.zshrc

echo "$descrim_end" >> $HOME/.zshrc

source $HOME/.zshrc

# bat is a `cat` with syntax highlighting
if [ ! -d $MYBIN/bat-v0.24.0-x86_64-unknown-linux-gnu ]; then
  curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  tar -zxf bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz
  ln -s bat-v0.24.0-x86_64-unknown-linux-gnu/bat bat
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
if [ ! -f $MYBIN/fzf ]; then
  ln -s $MYBIN/fzf_dir/bin/fzf $MYBIN/fzf
  ln -s $MYBIN/fzf_dir/bin/fzf-tmux $MYBIN/fzf-tmux
fi

# fzf-git is a fzf extension for git
if [ ! -d $MYBIN/fzf-git.sh ]; then
  git clone https://github.com/junegunn/fzf-git.sh.git
fi

# lazygit
if [ ! -d $MYBIN/lazygit ]; then
  mkdir -p $MYBIN/lazygit_dir
  pushd $MYBIN/lazygit_dir
  wget https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
  tar -zxf lazygit_0.44.1_Linux_x86_64.tar.gz
  rm lazygit_0.44.1_Linux_x86_64.tar.gz
  popd
  ln -s $MYBIN/lazygit/lazygit $MYBIN/lazygit
fi


#if temp tar files exist
temp_files="*.tar.gz *.tar.xz"
for file in $temp_files; do
  if [ -f $file ]; then
    rm $file
  fi
done

# ---------------- install nodejs ----------------
echo "installing nodejs"
if [ ! -d $HOME/.nvm ]; then
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
if [ ! -d $HOME/.cargo ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
source $HOME/.zshrc
rustup update

cargo install fd-find
cargo install ripgrep
