
function install_cargo_completions {
    if command -v rustup &>/dev/null; then
        rustup completions zsh cargo > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions/src/_cargo
    fi
}

    # install zsh plugins
function update {
    [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    
    # update if needed
    for plugin in ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/*; do
        if [ -d "$plugin/.git" ]; then
            echo "updating: $plugin"
            git -C "$plugin" pull
        fi
    done

    # run additional install tasks
    install_cargo_completions
}

update
