#!/bin/bash 
sudo mv /etc/portage/make.conf /home/vi/dotfiles/gentoo/spare
sudo mv /etc/portage/binrepos.conf /home/vi/dotfiles/gentoo/spare
sudo mv /etc/portage/package.accept_keywords /home/vi/dotfiles/gentoo/spare/
sudo mv /etc/portage/package.license /home/vi/dotfiles/gentoo/spare/
sudo mv /etc/portage/package.mask /home/vi/dotfiles/gentoo/spare/
sudo mv /etc/portage/package.use /home/vi/dotfiles/gentoo/spare/
sudo mv /etc/portage/profile /home/vi/dotfiles/gentoo/spare/
sudo mv /etc/portage/repos.conf /home/vi/dotfiles/gentoo/spare/
sudo mv /etc/portage/savedconfig /home/vi/dotfiles/gentoo/spare/
chmod +x /home/vi
chmod +x /home/vi/dotfiles
chmod +x /home/vi/dotfiles/gentoo
chmod +x /home/vi/dotfiles/gentoo/etc
chmod +x /home/vi/dotfiles/gentoo/etc/portage
sudo stow -d /home/vi/dotfiles -t / gentoo
