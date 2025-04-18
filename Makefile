all:
	stow --dotfiles -v -R .
clean:
	stow --dotfiles -v -D .
