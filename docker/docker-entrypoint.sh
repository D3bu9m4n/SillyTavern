#!/bin/sh

if [ ! -e "config/config.yaml" ]; then
    echo "Resource not found, copying from defaults: config.yaml"
    cp -r "default/config.yaml" "config/config.yaml"
fi

if [ ! -e "config/settings.json" ]; then
    echo "Resource not found, copying from defaults: settings.json"
    cp -r "default/settings.json" "config/settings.json"
fi

CONFIG_FILE="config.yaml"

# 根据环境变量修改 config.yaml
if [ "$LISTEN" = "true" ]; then
  sed -i 's/listen: .*/listen: true/' $CONFIG_FILE
fi

if [ "$WHITELIST_MODE" = "false" ]; then
  sed -i 's/whitelistMode: .*/whitelistMode: false/' $CONFIG_FILE
fi

if [ "$MULTIUSER_MODE" = "true" ]; then
  sed -i 's/enableUserAccounts: .*/enableUserAccounts: true/' $CONFIG_FILE
fi

if [ "$BASIC_AUTH_MODE" = "true" ]; then
  sed -i 's/basicAuthMode: .*/basicAuthMode: true/' $CONFIG_FILE
  sed -i "s/username: .*/username: \"$BASIC_AUTH_USERNAME\"/" $CONFIG_FILE
  sed -i "s/password: .*/password: \"$BASIC_AUTH_PASSWORD\"/" $CONFIG_FILE
fi

echo "Starting with the following config:"
cat $CONFIG_FILE

if grep -q "listen: false" $CONFIG_FILE; then
  echo -e "\033[1;31mThe listen parameter is set to false. If you can't connect to the server, edit the \"docker/config/config.yaml\" file and restart the container.\033[0m"
  sleep 5
fi

if grep -q "whitelistMode: true" $CONFIG_FILE; then
  echo -e "\033[1;31mThe whitelistMode parameter is set to true. If you can't connect to the server, edit the \"docker/config/config.yaml\" file and restart the container.\033[0m"
  sleep 5
fi
# Start the server
exec node server.js --listen
