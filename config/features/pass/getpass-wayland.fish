#!/usr/bin/env fish

pass -c (basename -s ".gpg" (ls ~/.password-store/*.gpg) | tofi)

# Lists all *.gpg
# Removes ".gpg" and path
# Lets you choose one in tofi
# pass -c to copy to clipboard
