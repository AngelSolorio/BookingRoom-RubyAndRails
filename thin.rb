---
pid: tmp/pids/thin.pid
address: 0.0.0.0
timeout: 30
wait: 30
port: 4000
log: log/thin.log
max_conns: 1024
require: []

environment: production
max_persistent_conns: 512
servers: 1
daemonize: true
chdir: /var/www/html/bookingroom/current