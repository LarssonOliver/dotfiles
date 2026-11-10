#!/usr/bin/env bash

# True (exit 0) on a Linux machine with no display server attached, e.g. a
# cloud dev VM. Headless is assumed to never apply outside Linux.
[ "$(uname -s)" = "Linux" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]
