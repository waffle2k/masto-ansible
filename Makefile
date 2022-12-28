install:
	ansible-galaxy install geerlingguy.docker geerlingguy.nginx
	git submodule update --init --recursive
