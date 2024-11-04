#!/usr/bin/env fish

if set -q WAYLAND_DISPLAY
  set menu tofi
else if set -q DISPLAY
  set menu dmenu
else
  set menu fzf
end

cd ~/.password-store/
pass -c (string replace ".gpg" "" (ls **.gpg) | $menu) &>/dev/null

# Lists all **.gpg
# Removes ".gpg"
# Lets you choose one in tofi/dmenu
# pass -c to copy to clipboard
