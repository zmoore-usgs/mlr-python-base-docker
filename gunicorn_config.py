import os
import gunicorns

bind_ip = os.getenv('bind_ip', '0.0.0.0')
bind_port = os.getenv('listening_port', '8443')
bind = '{0}:{1}'.format(bind_ip, bind_port)
capture_output = True

# ssl_key_path and ssl_cert_path environment variables are defined when secrets are created
keyfile = os.getenv('ssl_key_path')
certfile = os.getenv('ssl_cert_path')

gunicorn.SERVER_SOFTWARE = ''