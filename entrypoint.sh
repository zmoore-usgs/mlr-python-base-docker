#!/bin/ash
# shellcheck shell=dash

/bin/ash $HOME/import_certs.sh

if [ -f "app.py" ]; then
  gunicorn --reload app:app --config file:$HOME/local/gunicorn_config.py --user $USER
else
  gunicorn --reload app --config file:$HOME/local/gunicorn_config.py --user $USER
fi
