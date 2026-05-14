#!/bin/bash

set -e
set -x

cd /home/dewitars/.config/nvim/fork_source/ || exit
git fetch && git pull

cd .. || exit

_date=$(date +%Y_%m_%d_%H_%M_%S)
_backup_dir=".backup/$_date"

mkdir -p "$_backup_dir/lua"
mv init.lua "$_backup_dir/init.lua"
mv .stylua.toml "$_backup_dir/.stylua.toml"
mv lua/kickstart/ "$_backup_dir/lua/kickstart/"

cp fork_source/init.lua .
cp fork_source/.stylua.toml .
cp -r fork_source/lua/kickstart/ lua/
