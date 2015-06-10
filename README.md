homedir-bootstrap
=================

This is the repository for my home directory bootstrap script. Inspired by
[vcsh-home](https://github.com/vdemeester/vcsh-home.git), but with some
significant differences as well.

This script downloads and configures the vcsh and myrepos tools that I use to
manage my dotfiles, and configures vcsh hooks that causes checkout-out
repositories to ignore their README.md and LICENSE files when populating the
home directory, and to set permissions to desired values.
