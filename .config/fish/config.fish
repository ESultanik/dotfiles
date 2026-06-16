if status is-interactive
    # Commands to run in interactive sessions can go here
    
    set -gx GIT_EDITOR vim

    function dotfiles
        git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
    end
end

fish_add_path -g --append --path /usr/local/bin
fish_add_path -g --append --path ~/.local/bin

alias codex-cyber-preview='codex -m gpt-5.5-cyber-preview --config model_reasoning_effort="xhigh"'
alias codex-cyber='codex -m gpt-5.4-cyber --config model_reasoning_effort="xhigh"'

if type -q fnm
    fnm env --use-on-cd | source
end
