#!/bin/bash
# sftp deploy@45.79.77.254
# cd /home/deploy
# rm deploy.sh
# put deploy.sh

killall -SIGKILL ruby
cd /home/deploy/team7-backend
git pull
bundle
ruby server.rb > server.log &
disown

killall -SIGKILL grpcwebproxy
./bin/grpcwebproxy-v0.12.0-linux-x86_64 --allow_all_origins --backend_addr=localhost:10369 --run_tls_server=false --use_websockets --server_http_debug_port=10368 --websocket_ping_interval 5s --server_http_max_read_timeout 86400s &
disown

killall -SIGKILL yarn
cd /home/deploy/team7-frontend
git pull
yarn
yarn serve > client.log &
disown
