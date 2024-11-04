#!/usr/bin/env fish

set chosen_passwd (basename -s ".gpg" (ls ~/.password-store/*.gpg) | tofi)
