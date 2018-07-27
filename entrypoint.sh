#!/bin/ash
# shellcheck shell=dash

/bin/ash $HOME/import_certs.sh

/usr/bin/gunicorn --reload app --config file:$HOME/local/gunicorn_config.py --user $USER