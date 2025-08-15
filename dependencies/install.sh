rpm-ostree install --idempotent --allow-inactive -yA $(<./main.txt)

flatpak remote-add --if-not-existis flathub https://dl.flathub.org/repo/flathub.flatpakrepo
xargs flatpak install <flatpak.txt
xargs go install <go.txt
xargs cargo install <cargo.txt

# This must be run for the theme to actually work.
chmod +x /home/velasco/.config/base16-shell/scripts/base16-pop.sh

# Setting user terminal to zsh
chsh -s $(which zsh)

# Devpod config
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
devpod provider add docker -o DOCKER_PATH=$(which podman)
devpod ide use none
