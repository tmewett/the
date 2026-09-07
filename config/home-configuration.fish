if not set -q APPDATA; set APPDATA ~/.config; end
if not set -q USERPROFILE; set USERPROFILE ~; end

if set -q MSYSTEM
    set vscode_config_dir $USERPROFILE/scoop/persist/vscodium/data/user-data
else
    set vscode_config_dir $APPDATA/Code
end

if not set -q MSYSTEM
    idem_symlink $my_config_dir/exec-nopasswd $HOME/exec-nopasswd
end

idem_symlink_native $my_config_dir/settings.json $vscode_config_dir/User/settings.json
idem_symlink_native $my_config_dir/keybindings.json $vscode_config_dir/User/keybindings.json
idem_symlink_native $my_config_dir/snippets $vscode_config_dir/User/snippets

idem_symlink_native $my_config_dir/lazygit/config.yml ~/.config/lazygit/config.yml

idem_symlink $my_config_dir/fish/functions ~/.config/fish/functions

# ControlMaster is broken on Windows
if not set -q MSYSTEM
    idem_symlink $my_config_dir/ssh_config ~/.ssh/config
end

if set -q MSYSTEM
    idem_rm_symlink $USERPROFILE/keymapper.conf
else
    idem_rm_symlink ~/.config/keymapper.conf
end
