# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure git and stow are installed

```
pacman -S git stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
git clone --recurse-submodules git@github.com:Velasko/dotfiles.git
cd dotfiles
```

then, go to ./home and use GNU stow to create symlinks

```
stow --target ~/ .
```
