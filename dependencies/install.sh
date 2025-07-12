rpm-ostree install --idempotent --allow-inactive -yA $(<./main.txt)
xargs go install <go.txt
xargs cargo install <cargo.txt

chsh -s $(which zsh)
