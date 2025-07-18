rpm-ostree install --idempotent --allow-inactive -yA $(<./main.txt)
xargs flatpak install <flatpak.txt
xargs go install <go.txt
xargs cargo install <cargo.txt

# This must be run for the theme to actually work.
chmod +x /home/velasco/.config/base16-shell/scripts/base16-pop.sh

# Setting user terminal to zsh
chsh -s $(which zsh)
