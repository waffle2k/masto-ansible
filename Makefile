install:
	ansible-galaxy install geerlingguy.docker geerlingguy.nginx geerlingguy.certbot
	git submodule update --init --recursive
