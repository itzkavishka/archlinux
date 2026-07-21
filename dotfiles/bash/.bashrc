#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# FastFetch
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi


# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi


# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# LS
alias ls='ls --color=auto'
alias ll='ls -lha --color=auto'
# Configure color scheme for `ls` command output 
export LS_COLORS='di=34:fi=0:ln=36:pi=33:so=32:do=35:bd=33;1:cd=33;1:or=31;1:mi=31;1:su=37;41:sg=30;43:tw=30;42:ow=30;43:st=37;44:'

# Grep
alias grep='grep --color=auto'

# Set the prompt to show the current directory and user
PS1='[\u@\h \W]\$ '

# Extra
alias cp='cp -i'
alias vi='vim'
alias mkdir='mkdir -p'

# Permission
#alias mx='chmod a+x'
#alias 000='chmod -R 000'
#alias 644='chmod -R 644'
#alias 666='chmod -R 666'
#alias 755='chmod -R 755'
#alias 777='chmod -R 777'

# Dirs
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias docs='cd ~/Documents'
alias downs='cd ~/Downloads'
alias vids='cd ~/Videos'
alias pics='cd ~/Pictures'

# Function to enable conservation mode
conservation_on() {
    echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC*/conservation_mode
}

# Function to disable conservation mode
conservation_off() {
    echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC*/conservation_mode
}

# Pacman
alias pacupdate='sudo pacman -Syu'
alias pacinstall='sudo pacman -S'
alias pacuninstall='sudo pacman -Rns'
alias pacsearch='sudo pacman -Ss'
alias paccache-clean='sudo pacman -Sc'
alias paccache-clear='sudo pacman -Scc'
alias pacorphan='orphaned=$(pacman -Qtdq); if [ -n "$orphaned" ]; then sudo pacman -Rns $orphaned; else echo "No orphaned packages found."; fi'

#Trizen(AUR Helper)
alias tupdate='trizen -Syu'
alias tinstall='trizen -S'
alias pacuninstall='trizen -Rns'
alias tsearch='trizen -Ss'
alias tcache-clean='trizen -Sc'
alias tcache-clear='trizen -Scc'

# Power
alias suspend='systemctl suspend'

# External Drive Mount
alias emount='sudo mount /dev/sdb1 /mnt/ && cd /mnt/ && ls || echo "Mount or dir change failed."'
alias eumount='sudo umount /mnt/ && echo "Unmounted successfully." || echo "Failed to unmount."'

# Edit the .bashrc file
alias ebrc='vim ~/.bashrc'

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

bb() {
    local level value

    while true; do
        read -p "Brightness (1-10): " level
        if [[ "$level" =~ ^([1-9]|10)$ ]]; then
            break
        fi
        echo "Enter a value between 1 and 10."
    done

    if [ "$level" -eq 10 ]; then
        value="1.0"
    else
        value="0.$level"
    fi

    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        # Wayland: use brightnessctl (hardware backlight, requires brightnessctl)
        local pct=$(( level * 10 ))
        if command -v brightnessctl &>/dev/null; then
            brightnessctl set "${pct}%"
            echo "brightness -> ${pct}%"
        else
            echo "brightnessctl not found. Install it: sudo apt install brightnessctl"
            return 1
        fi
    else
        # X11: use xrandr software brightness
        local display
        display=$(xrandr --query | awk '/ connected/{print $1; exit}')
        if [ -z "$display" ]; then
            echo "No display detected."
            return 1
        fi
        xrandr --output "$display" --brightness "$value" --gamma 1:1:1
        echo "$display -> brightness $level/10 ($value)"
    fi
}
