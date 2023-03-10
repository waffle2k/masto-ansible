install:
	ansible-galaxy install geerlingguy.docker geerlingguy.nginx
	git submodule update --init --recursive

upgrade:
	ansible-playbook upgrade-playbook.yml

yttrx:
	ansible-playbook yttrx-playbook.yml 

mastodon-first-install:
	ansible-playbook mastodon-playbook.yml --tags install,configure --extra-vars "first_install=True"

mastodon:
	ansible-playbook mastodon-playbook.yml --tags install,configure
mastodon-config:
	# Used for updating the .env.production settings
	ansible-playbook mastodon-playbook.yml --tags configure

frontend:
	ansible-playbook mastodon-playbook.yml --tags install,configure --limit 'frontend' --extra-vars "install_frontend=True"
frontend-config:
	ansible-playbook mastodon-playbook.yml --tags configure --limit 'frontend' --extra-vars "install_frontend=True"

webapp:
	ansible-playbook mastodon-playbook.yml --tags install,configure --limit 'webapp' --extra-vars "install_webapp=True"
webapp-config:
	ansible-playbook mastodon-playbook.yml --tags configure --limit 'webapp' --extra-vars "install_webapp=True"

sidekiq:
	ansible-playbook mastodon-playbook.yml --tags install,configure --limit 'sidekiq' --extra-vars "install_sidekiq=True"
sidekiq-config:
	ansible-playbook mastodon-playbook.yml --tags configure --limit 'sidekiq' --extra-vars "install_sidekiq=True"
