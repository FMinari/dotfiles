function dots --wraps git --description "git das configs do rice (repo bare em ~/.dotfiles). Ajuda: ~/.config/rice/README.md"
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
end
