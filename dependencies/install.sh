rpm-ostree install --idempotent --allow-inactive -yA $(<./main.txt)

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

BIN=~/.local
mkdir -p $BIN/bin

xargs flatpak install --or-update --assumeyes --noninteractive <flatpak.txt
GOPATH=$BIN xargs go install <go.txt
xargs cargo install --root $BIN <cargo.txt

hostnamectl set-hostname velasko-desktop

git config --global user.email "f.l.velasko@gmail.com"
git config --global user.name "Luís Filipe Velasco da Silva"

# This must be run for the theme to actually work.
chmod +x /home/velasco/.config/base16-shell/scripts/base16-pop.sh

# Setting user terminal to zsh
chsh -s $(which zsh)

# Devpod config
#curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
#devpod provider add docker -o DOCKER_PATH=$(which podman)
#devpod ide use none
