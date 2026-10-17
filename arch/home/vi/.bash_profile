#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -e /home/vi/.nix-profile/etc/profile.d/nix.sh ]; then . /home/vi/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
