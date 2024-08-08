









## WIKI
1. GTK Theme installation
	
	- ```sudo pacman -S arc-gtk-theme```
	
	- ```mkdir ~/.config/gtk-3.0```
	
	- ```echo -e "[Settings]\ngtk-theme-name=Arc-Dark" > ~/.config/gtk-3.0/settings.ini```

2. AUR Helper Setup
	
	- ```sudo pacman -Syu git base-devel```
	
	- AUR Helpers
		-  ```git clone https://aur.archlinux.org/yay.git```
		-  ```git clone https://aur.archlinux.org/trizen.git``` (personal fav)
		-  ```git clone https://aur.archlinux.org/paru.git```
	 
	- clone the repo and cd in to the file
	
	- Run ```makepkg -si``` command without sudo.
