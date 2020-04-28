## PeerStreet Hackathon 2020 — Backend

Our main idea was simple: we want to show that it's possible to separate
domain modal from implementation and maintain this model as the first-class project.
We created 3 repos connected:

1. **Domain model** (Protobuf 3 + Rake task to build Ruby gem and Js/Ts package): [0x000000/team7-domain](https://github.com/0x000000/team7-domain)
2. **Front-end** (Vue-cli + typescript): [Kaciaryna/team7-frontend](https://github.com/Kaciaryna/team7-frontend)
3. **Back-end** (Ruby + grpc): [0x000000/team7-backend](https://github.com/0x000000/team7-backend)

## Project Structure

We created a simple server implementing `LoanService` [described here](https://github.com/0x000000/team7-domain/blob/master/definitions/api/private/loans_service.proto)

* `server.rb` — main entry, we do all setup here.
* `services/loan_service.rb` — simple implementation of `LoanService`.
* `helpers/data_generator.rb` — semi-random generator for initial data: `User`, `Loan` and `Address` models.
* `helpers/logger.rb` — simple logger for grpc server.
* `bin/grpcwebproxy-v0.12.0-*` — *nix versions of pre-built binaries for the simple proxy server.
This server is only required for web clients.

### Setup

1. `$ bundle`
2. `$ ./bin/grpcwebproxy{linux/osx} --allow_all_origins --backend_addr=localhost:10369 --run_tls_server=false --use_websockets --server_http_debug_port=10368 --websocket_ping_interval 5s --server_http_max_read_timeout 86400s &`
3. `$ ruby server.rb`
