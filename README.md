# Dotfiles

These [dotfiles][1] are managed with [rcm][2]. The repository contains
configuration files as well as binaries of used helper tools (including `rcm`
itself) in order to reduce dependencies and make installation easy.

[1]: https://dotfiles.github.io/
[2]: https://github.com/thoughtbot/rcm


### Initial setup

Run the following commands to install the dotfiles on a new machine:

```shell
git clone https://github.com/carlfriedrich/dotfiles.git ~/.dotfiles
RCRC=~/.dotfiles/rcrc PATH=~/.dotfiles/local/bin/:${PATH} ~/.dotfiles/local/bin/rcup -v
exec bash -l
```

## Contained tools

The following tools are contained in these dotfiles in binary or script form:

- [**bat**](https://github.com/sharkdp/bat)  
  A `cat` clone with syntax highlighting, Git integration and line numbering

- [**diff-so-fancy**](https://github.com/so-fancy/diff-so-fancy)  
  Beautiful human readable diffs

- [**exa**](https://github.com/ogham/exa)  
  A modern replacement for `ls` with colours, icons and Git status

- [**fd**](https://github.com/sharkdp/fd)  
  User-friendly alternative to `find`

- [**forgit**](https://github.com/wfxr/forgit)  
  `fzf` integration for Git

- [**fzf**](https://github.com/junegunn/fzf)  
  A general-purpose command-line fuzzy finder

- [**navi**](https://github.com/denisidoro/navi)  
  Interactive cheatsheet tool

- [**print256colours**](https://gist.github.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263)  
  Print all 256 colours to the terminal

- [**rcm**](https://github.com/thoughtbot/rcm)  
  Tool for dotfiles management

- [**ripgrep**](https://github.com/BurntSushi/ripgrep)  
  Fast and user-friendly `grep` alternative

- [**sd**](https://github.com/chmln/sd)  
  Intuitive find & replace CLI, replacement for `sed`

- [**starship**](https://github.com/starship/starship)  
  Minimal, fast and infinitely customizable prompt

- [**vscode-updateenv**](https://superuser.com/a/1613931/1036029)  
  Make VS Code work in `screen` sessions

- [**zoxide**](https://github.com/ajeetdsouza/zoxide)  
  A `cd` replacement to quickly jump into recently used directories


## Contained configuration

Here is a list of tools that these dotfiles contain configuration for:

- [**bash**](https://linux.die.net/man/1/bash)
- [**cp**](https://linux.die.net/man/1/cp) / [**mv**](https://linux.die.net/man/1/mv)
- [**git**](https://linux.die.net/man/1/git)
- [**history**](https://linux.die.net/man/1/history)
- [**kubectl**](https://kubernetes.io/docs/reference/kubectl/)
- [**ls**](https://linux.die.net/man/1/ls)
- [**less**](https://linux.die.net/man/1/less)
- [**man**](https://linux.die.net/man/1/man)
- [**screen**](https://linux.die.net/man/1/screen)
- [**tig**](https://github.com/jonas/tig)
- [**tilde**](https://github.com/gphalkes/tilde)


## Keybindings

These dotfiles come with a set of preconfigured bash keybindings:

- **Interactive History search** <kbd>**Ctrl**</kbd>+<kbd>**R**</kbd>  
  Opens an `fzf` window containing the bash history to interactively search for
  previously executed commands. Press `Enter` to select a command and insert it
  into your promt.

- **Interactive file search** <kbd>**Ctrl**</kbd>+<kbd>**T**</kbd>  
  Opens an `fzf` window containing all files within the current directory and
  its subdirectories. Press `Enter` to select a file and insert it into your
  prompt.

- **Interactive find in files** <kbd>**Ctrl**</kbd>+<kbd>**F**</kbd>  
  Opens an `fzf` window executing a `ripgrep` search in the current directory
  using the entered search string. Press `Enter` to open the file in your
  default editor. Press `Alt+Enter` to open it without closing the `fzf` window.

- **Interactive git log** <kbd>**Ctrl**</kbd>+<kbd>**G**</kbd>  
  Runs `git forgit` for interactive git history.

- **Interactive cheat sheet** <kbd>**Ctrl**</kbd>+<kbd>**Space**</kbd>  
  Opens `navi` for interactive selection of configured cheat sheets.


## Dotfile management

### Standard rcm commands

There are two essential commands from the [rcm][3] package that are used for
managing the dotfiles:

- [**`mkrc`**][4]  
  Add a new file to the dotfiles directory. This should be called whenever a
  dotfile shall be put under version control. Example:

  ```shell
  carl@desktop:~$ mkrc .myconfig
  Moving...
  '/home/carl/.myconfig' -> '/home/carl/.dotfiles/myconfig'
  Linking...
  '/home/carl/.dotfiles/myconfig' -> '/home/carl/.myconfig'
  ```

  Aftwards the new dotfile can be added and committed to git within the
  `~/.dotfiles` directory.

- [**`rcup`**][5]  
  Update dotfiles. This should be called after pulling changes from the upstream
  git repository in order to have them applied locally. Example:

  ```shell
  carl@desktop:~$ rcup
  identical /home/carl/.bash_aliases
  identical /home/carl/.bash_completion
  identical /home/carl/.bashrc
  '/home/carl/.dotfiles/myconfig' -> '/home/carl/.myconfig'
  ```

[3]: https://github.com/thoughtbot/rcm
[4]: http://thoughtbot.github.io/rcm/mkrc.1.html
[5]: http://thoughtbot.github.io/rcm/rcup.1.html


### Helper scripts

To make the handling of the dotfiles even easier, there are a few custom helper
scripts in this repository:

- **`sbrc`**  
  Alias for `source ~/.bashrc`. This should be called after pulling upstream
  changes in order to reload the `.bashrc` file for the current shell.

- **`rcbl`**  
  Searches for broken links to dotfiles in your home directory and lists them.
  This should be called after `rcup` if any dotfiles have been moved, removed
  or renamed upstream.

- **`rcbld`**  
  Deletes broken links to dotfiles in your home directory. This should be called
  if `rcbl` reports broken links due to moved, removed or renamed dotfiles.

- **`dv`**
  Displays the dotfiles version using `git describe`.


## Local customization

Extensions to `.bashrc` and `.gitconfig` that shall not be under version control
can be configured in `~/.bashrc_local` and `~/.gitconfig_local`, respectively.
These files will automatically be loaded if they exist.
