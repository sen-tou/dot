if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.zaliases" ]; then
    source "$HOME/.zaliases"
fi

if [ -f "$HOME/.os_specifics" ]; then
    source "$HOME/.os_specifics"
fi
