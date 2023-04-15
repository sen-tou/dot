if [ -f "$HOME/.zaliases" ]; then
    source "$HOME/.zaliases"
fi

if [ -f "$HOME/.os_specifics" ]; then
    source "$HOME/.os_specifics"
fi
