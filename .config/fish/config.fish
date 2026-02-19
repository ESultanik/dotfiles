if status is-interactive
    # Commands to run in interactive sessions can go here
    
    set -gx GIT_EDITOR vim

    function dotfiles
        git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
    end
end
