import os
import gunicorn

bind_ip = os.getenv('bind_ip', '0.0.0.0')
bind_port = os.getenv('listening_port', '8443')
bind = '{0}:{1}'.format(bind_ip, bind_port)
capture_output = True

# ssl_key_path and ssl_cert_path environment variables are defined when secrets are created
keyfile = os.getenv('ssl_key_path')
certfile = os.getenv('ssl_cert_path')

# Settings to hopefully help stability on Docker in AWS
# See: https://github.com/benoitc/gunicorn/issues/1194
keepalive = int(os.getenv('gunicorn_keep_alive', 75))
timeout = int(os.getenv('gunicorn_silent_timeout', 120))
grceful_timeout = int(os.getenv('gunicorn_graceful_timeout', 120))
worker_class = 'gevent'
ciphers = 'TLSv1.2'

gunicorn.SERVER_SOFTWARE = ''