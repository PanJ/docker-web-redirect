#!/bin/bash
if [ -z "$REDIRECT_TARGET" ]; then
	echo "Redirect target variable not set (REDIRECT_TARGET)"
	exit 1
else
	# Add http if not set
	if ! [[ $REDIRECT_TARGET =~ ^https?:// ]]; then
		REDIRECT_TARGET="http://$REDIRECT_TARGET"
	fi

	# Add trailing slash
	if [[ ${REDIRECT_TARGET:length-1:1} != "/" ]]; then
		REDIRECT_TARGET="$REDIRECT_TARGET/"
	fi

	echo "Redirecting HTTP requests to ${REDIRECT_TARGET}..."
fi

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
	listen 80;
  location /healthz {
    access_log off;
    return 200;
    break;
  }
  location / {
    return 301 $REDIRECT_TARGET\$request_uri;
  }
}
EOF

nginx -g "daemon off;"
