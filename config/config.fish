# My portable config. System-specific goes in the real config.fish

set -x MSYS2_ENV_CONV_EXCL "$MSYS2_ENV_CONV_EXCL;GEM_PATH"

# reset to default in case it was set in a parent
set -e MSYS2_ARG_CONV_EXCL

# -F - quit if one screen
# -j .5 - search results appear in middle of screen
# -R - don't escape colours and text effects
# -P prompt - the default medium/-m prompt, modified to always show the file
#   (not just on first prompt) and appended with help info like 'man'
set -x LESS "-F -j .5 -R -P ?f%f :- .?m(%T %i of %m) .?e(END) ?x- Next\: %x.:?pB%pB\%:byte %bB?s/%s...%t (press h for help or q to quit)\$"

# this doesn't take into account ignorefiles
set -x FZF_DEFAULT_COMMAND "find . \( -name .git -or -name \*venv \) -prune -or ! -type d -printf '%P\n'"

function sudo
    echo "  $(string escape -- sudo $argv | string join ' ')"
    if test "$(read -P "run this command? (y/N) ")" != "y"
        return 1
    end
    command sudo ~/exec-nopasswd $argv
end
function _reversed_prompt_cwd
    set cwd (string split / -- (prompt_pwd))
    echo -n $cwd[-1]
    for part in $cwd[-2..1]
        echo -n "\\$part"
    end
end
if status is-interactive
    abbr -a -- g t w lazygit
    abbr -a -- S sudo pacman -S --needed
    abbr -a -- Rn sudo pacman -Rn
    abbr -a -- Dd sudo pacman -D --asdeps
    fish_hybrid_key_bindings
    function sudo
        command sudo ~/exec-nopasswd $argv
    end
    function c --wraps=cd
        cd $argv
        and ls
    end
    function nuke
        # -R also makes chmod ignores symlinks, so we can't use find -exec chmod
        chmod -R 777 $argv[1]
        and rm -r $argv[1]
    end
    function fish_greeting; end
    function fish_title
        echo -n $_ ' '
        _reversed_prompt_cwd
    end
    complete -c w -e
    complete -c w -w exec
    function prepare-backup
        pushd $tom/files/projects
        or return 1
        for d in *
            cd $d
            w git gc
            cd ..
        end
        popd
    end
    function backup
        pushd $tom/files
        or return 1
        ~/borg.venv/bin/python -m borg create -C auto,zstd --progress --patterns-from borg-filter ::windows-from-msys2-\{now\} . ../AppData/vault
    end
end

set -e fish_user_paths
set -p PATH ~/.local/bin $the_dir/config/bin $the_dir/idem $the_dir/homestead ~/.bun/bin ~/.local/share/pnpm/bin ~/go/bin

if test -e /c/Users/tom
    set -x tom /c/Users/tom
end

# rustup
if test -e $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end
