This is the script I use to bootstrap a new server.

It will:

* Create a user (can be parsed as argument - otherwise your username will be used)
* Make the user a sudo user without password
* Put your public ssh key in the authorized_keys file
* Install zsh and make it the default for the user

It will optionally:

* Install dotfiles from lasseebert/dotfiles
