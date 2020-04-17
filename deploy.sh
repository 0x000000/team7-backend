#!/bin/bash
# sftp deploy@45.79.77.254
# cd /home/deploy && put deploy.sh

killall -SIGKILL ruby
cd /home/deploy/team7-backend
git pull
bundle
ruby server.rb > server.log &
disown

killall -SIGKILL yarn
cd /home/deploy/team7-frontend
git pull
yarn
yarn serve > client.log &
disown
