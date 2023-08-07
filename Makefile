current_dir := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

.PHONY=install
install:
	ln -s $(current_dir) $(HOME)/.emacs.d
