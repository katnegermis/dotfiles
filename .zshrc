# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="katnegermis"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git command-not-found pip screen virtualenvwrapper virtualenv virtualenv-prompt)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH

## Add autojump

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u


#### Exports
export koding='~/dropbox/koding/'
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper_lazy.sh
# Add GOPATH to PATH
export GOPATH=~/coding/go
export GOBIN=/opt/go/bin
export GOROOT=/opt/go
#export GOPATH=/usr/local/go
export PATH=$PATH:/opt/go/bin
export SCALA_HOME=/opt/scala/
export PATH=$PATH:$SCALA_HOME/bin/
export PATH=$PATH:/opt/sbt/bin/
# add cabal dir to path (haskell-thing for pandoc)
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$PATH:/opt/genymobile/genymotion
export PATH=$PATH:/opt/ida
export LESS='-Ri'
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim


#### Function declarations
urldecode_alias() {
    python -c "import urllib, sys; print urllib.unquote(sys.argv[1])" "$@"
}
urlencode_alias() {
    python -c "import urllib, sys; print urllib.quote(sys.argv[1])" "$@"
}

todo_today_alias() {
    DATE=$(date +%y.%m.%d)
    vim ~/todo/todo_$DATE
}

dockerip () { docker inspect "$@" | egrep '"IPAddress": "' | egrep -o '([0-9]+.[0-9]+.[0-9]+.[0-9]+)'; }
dockerrm () { sudo docker stop "$@" && sudo docker rm -v "$@" }

#### Aliases
alias vi=vim
alias todo="vi ~/todo/todo.txt"
alias ttodo="vi ~/thesis/dump/notes.md"
alias se=~/coding/python/series_everything/tvshowhelper.py
alias wn="se $@ --watch-next"
alias s="apt search"
alias i='sudo apt install'
alias zshrc="vim ~/.zshrc"
alias o=xdg-open
alias sshfs_gk="sshfs gk:/ /media/katnegermis/sw"
alias sshfs_hjemme="sshfs hjemme:/ /media/katnegermis/hjemme"
alias youtube-mp3="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0"
alias youtube-mp3ffmpeg="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 --prefer-ffmpeg"
alias urldecode=urldecode_alias
alias urlencode=urlencode_alias
alias pdf=pandocpdf_alias
alias todotoday=todo_today_alias
alias v=vim
alias cb='xclip -sel clip'

alias lsa='ls -lah'
alias l='ls'
alias ll='ls -lh'
alias la='ls -lAh'
alias sshpw='ssh -o PreferredAuthentications=password'
alias scppw='scp -o PreferredAuthentications=password '
alias ord='~/coding/python/ordbogen_free/ord.py '
alias suspend='sudo pm-suspend'
alias arbtt-stats-today='arbtt-stats --filter "\$date >= $(date +%Y-%m-%d)"'
alias arbtt-stats-24h='arbtt-stats --filter "\$sampleage <= 24:00"'
alias ida64='wine ~/.wine/drive_c/Program\ Files\ \(x86\)/IDA\ 6.5/idaq64.exe'
alias ida='wine ~/.wine/drive_c/Program\ Files\ \(x86\)/IDA\ 6.5/idaq.exe'
alias wifi='sudo nmcli nm wifi '
alias wificonnect='nmcli dev wifi connect "$1" iface wlan0 '
alias doirssi='ssh gk -t screen -d -r irssi'
alias mdsec='egrep -e "^(-------|=======|#{2,6})" -B 1 -A0 --color=never'
alias dco=docker-compose
alias pgadmin4="python /usr/local/lib/python2.7/dist-packages/pgadmin4/pgAdmin4.py"
dockerclean() { sudo docker volume ls -qf dangling=true | xargs -r docker volume rm; }
alias sz=streamzor-cli
dockerip () { sudo docker inspect "$@" | egrep '"IPAddress": "' | egrep -o '([0-9]+.[0-9]+.[0-9]+.[0-9]+)'; }

alias startgamer="wakeonlan 2c:56:dc:3c:c1:ce"


# Add git-stuff to tmux status bar.
source ~/dotfiles/.tmux-git/tmux-git.sh
precmd() {
    update_tmux
}

stty -ixon
export SPARK_HOME=/home/katnegermis/thesis/simba/Simba/engine/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export SPARK_LOCAL_IP=127.0.0.1

# Automatically load tmux
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && [[ -z "$NOTMUX" ]] && exec tmux
