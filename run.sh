#!/usr/bin/env bash

service ssh start
service x2goserver start

/usr/local/bin/emacs --fg-daemon
