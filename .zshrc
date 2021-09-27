# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/luciano/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
function proy() {
	cd /mnt/windows/Users/luciano/Documents/proyectos
}
function fing() {
	cd /mnt/windows/Users/luciano/Documents/fing
}
function grafo() {
	nohup zathura /mnt/windows/Users/luciano/Documents/fing/GrafoPrevias_Feb2021.pdf
}
function netlabs() {
	cd /home/luciano/Documents/netlabs
}
export PATH=/home/luciano/.local/bin:$PATH
export PATH="/home/luciano/scripts:$PATH"
export PATH="/home/luciano/go/bin:$PATH"


# Raspberry pi cluster functions
# cluster management functions

#   list what other nodes are in the cluster
function pi-cluster-other-nodes {
    grep "pi" /etc/hosts | awk '{print $2}' | grep -v $(hostname)
}

#   execute a command on all nodes in the cluster
function pi-cluster-cmd {
    for node in $(pi-cluster-other-nodes);
    do
        echo $node;
        ssh -t $node "$@";
    done
}

#   reboot all nodes in the cluster
function pi-cluster-reboot {
    pi-cluster-cmd sudo reboot now
}

#   shutdown all nodes in the cluster
function pi- cluster-shutdown {
    pi-cluster-cmd sudo shutdown now
}

function pi-cluster-scp {
    for node in $(pi-cluster-other-nodes);
    do
        echo "${node} copying...";
        cat $1 | ssh $node "sudo tee $1" > /dev/null 2>&1;
    done
    echo 'all files copied successfully'
}

#   start yarn and dfs on cluster
function pi-cluster-start-hadoop {
    start-dfs.sh; start-yarn.sh
}

#   stop yarn and dfs on cluster
function pi-cluster-stop-hadoop {
    stop-dfs.sh; stop-yarn.sh
}


export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin

export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH


export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HIVE_HOME=/opt/hive
export PATH=$PATH:/opt/hive/bin
export DEVDATA=~/Documents/netlabs/spark-hadoop/training_materials/devsh/data
export DEVSH=~/Documents/netlabs/spark-hadoop/training_materials/devsh
export PYSPARK_PYTHON=/usr/bin/python2
