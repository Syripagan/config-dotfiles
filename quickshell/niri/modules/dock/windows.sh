#!/usr/bin/env bash
niri msg windows | grep 'App ID:' | sed 's/.*App ID: "\(.*\)"/\1/' | sort -u > /tmp/niri_windows