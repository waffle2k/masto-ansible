# Installing the dependencies

Run `make` to install the necessary 3rd party roles, namely:
- geerlingguy.docker
- geerlingguy.nginx
- geerlingguy.certbot
- neovim & oh-my-zsh roles

The last two just make the server environments more akin to how I prefer them to be. It's easy enough to block this out, just edit `roles/yttrx/meta/main.yml` and remove `ansible-role-neovim` and `ansible-role-oh-my-zsh`.

## Unsupported

This currently doesn't manage anything related to your redis or postgres work.  I'll get to that later, but right now the redis and postgres portions are the oldest parts of my manually installed mastodon instance, and I am not ready to tear that down.

## Configuring your .env.production

Mastodon is configured with the `.env.production` file. This is populated with the hash configured in `roles/mastodon/vars/main.yml`.  This file contains sensitive information such as passwords etc., so it's better if we don't accidentally leak that to github, as such, that file i s in the `.gitignore` file.  I'll talk about how to configure it below.

```
cat roles/mastodon/vars/main.yml
---
ENV_PRODUCTION:
  LOCAL_DOMAIN: changeme
  SINGLE_USER_MODE: 'false'
  SECRET_KEY_BASE: changeme
  OTP_SECRET: changeme
  VAPID_PRIVATE_KEY: changeme
  VAPID_PUBLIC_KEY: changeme
  DB_HOST: pgbouncer
  DB_PORT: 5432
  DB_NAME: mastodon_production
  DB_USER: mastodon
  DB_PASS: foobar
  REDIS_HOST: changeme
  REDIS_PORT: 6379
  REDIS_PASSWORD:
  SMTP_SERVER: changeme
  SMTP_PORT: 25
  SMTP_AUTH_METHOD: none
  SMTP_OPENSSL_VERIFY_MODE: none
  SMTP_ENABLE_STARTTLS: auto
  SMTP_FROM_ADDRESS: changeme
  S3_ENABLED: 'true'
  S3_PROTOCOL: https
  S3_BUCKET: changeme
  S3_REGION: changeme
  S3_HOSTNAME: changeme
  S3_ENDPOINT: changeme
  AWS_ACCESS_KEY_ID: changeme
  AWS_SECRET_ACCESS_KEY: changeme
  S3_ALIAS_HOST: changeme
  STATSD_ADDR: statsd:9125
swap_space: 1G
```

## Configuring sidekiq workers

It's easy to spin up additional worker capacity.  Edit the `hosts` file, and add your new hostnames under the `[sidekiq]` line, then from the terminal, run `ansible-playbook sidekiq.yml`.  This will configure the host with all of the basic `yttrx` role stuff, including shell and nvim niceties, it will install docker, checkout the mastodon github repo, and configure the `docker-compose.yml` & `docker-compose.override.yml` files.

The `docker-compose.yml` file is managed by the `mastodon` role, and will simply install the `pgbouncer` and `statsd` containers. These are basic container required by all roles.  Role specific configurations will go into the `docker-compose.override.yml` file.

### Configuring how many sidekiq workers and which queues they'll process

Edit the `sidekiq.yml` file and configure the `sidekiq` var.  The expected format is:

```
  vars:
    sidekiq:
      - name: ingress-and-stuff
      - q: [ '-q', 'ingress', '-q', 'default' ]
```

This will create a service called `sidekiq-ingress-and-stuff` with the `ingress` and `default` queues.  To have the default queues, leave the `q` array empty.
