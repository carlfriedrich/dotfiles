# Dotfiles

These dotfiles are managed with [rcm][1]. The repository contains configuration
files as well as binaries of used helper tools (including `rcm` itself) in order
to reduce dependencies.

[1]: https://github.com/thoughtbot/rcm


### Initial setup

Run the following commands to install the dotfiles on a new machine:

```shell
git clone https://github.com/carlfriedrich/dotfiles.git ~/.dotfiles
RCRC=~/.dotfiles/rcrc PATH=~/.dotfiles/local/bin/:${PATH} ~/.dotfiles/local/bin/rcup -v
exec bash -l
```
