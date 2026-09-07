if not set -q APPDATA; set APPDATA ~/.config; end
if not set -q USERPROFILE; set USERPROFILE ~; end

if set -q MSYSTEM
    set vscode_config_dir $USERPROFILE/scoop/persist/vscodium/data/user-data
else
    set vscode_config_dir $APPDATA/Code
end

if not set -q MSYSTEM
    idem_symlink $the_dir/config/exec-nopasswd $HOME/exec-nopasswd
end

idem_symlink_native $the_dir/config/settings.json $vscode_config_dir/User/settings.json
idem_symlink_native $the_dir/config/keybindings.json $vscode_config_dir/User/keybindings.json
idem_symlink_native $the_dir/config/snippets $vscode_config_dir/User/snippets

idem_symlink_native $the_dir/config/lazygit-config.yml ~/.config/lazygit/config.yml

idem_rm_symlink ~/.config/fish/functions

# ControlMaster is broken on Windows
if not set -q MSYSTEM
    idem_symlink $the_dir/config/ssh_config ~/.ssh/config
end

if set -q MSYSTEM
    idem_rm_symlink $USERPROFILE/keymapper.conf
else
    idem_rm_symlink ~/.config/keymapper.conf
end
