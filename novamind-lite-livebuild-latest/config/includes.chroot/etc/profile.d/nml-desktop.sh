#!/bin/bash
if [ -n "$XDG_SESSION_TYPE" ] && [ -x /usr/local/bin/nml-session-select.sh ]; then
  /usr/local/bin/nml-session-select.sh >/dev/null 2>&1
fi
