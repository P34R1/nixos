#!/usr/bin/env fish

if set -q WAYLAND_DISPLAY
  set menu tofi
else if set -q DISPLAY
  set menu dmenu
else
  set menu fzf
end

pass -c (basename -s ".gpg" (ls ~/.password-store/*.gpg) | $menu)

# Lists all *.gpg
# Removes ".gpg" and path
# Lets you choose one in tofi/dmenu
# pass -c to copy to clipboard
