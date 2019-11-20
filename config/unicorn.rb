app_path          = "/home/ubuntu/projects/auction_my_deal_backend"
working_directory "#{app_path}"
pid               "#{app_path}/tmp/pids/unicorn.pid"
stderr_path       "#{app_path}/log/unicorn.log"
stdout_path       "#{app_path}/log/unicorn.log"

listen            "/tmp/unicorn.auction.sock"
worker_processes  1
timeout           600
preload_app       true
