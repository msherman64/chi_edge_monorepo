#!/usr/bin/env bash
# For each submodule: fetch origin, then report how many commits its HEAD
# is behind origin's default branch.
set -u

git submodule foreach --quiet '
    git fetch --quiet origin
    branch=$(git config -f "$toplevel/.gitmodules" --get "submodule.$name.branch" || true)
    if [ -n "$branch" ]; then
        upstream="origin/$branch"
    else
        upstream=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/master)
    fi
    behind=$(git rev-list --count HEAD..$upstream 2>/dev/null || echo "?")
    ahead=$(git rev-list --count $upstream..HEAD 2>/dev/null || echo "?")
    if [ "$behind" != "0" ] || [ "$ahead" != "0" ]; then
        printf "%-25s behind %s by %s, ahead by %s\n" "$name" "$upstream" "$behind" "$ahead"
    fi
'