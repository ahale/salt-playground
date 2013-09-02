swift_version:              "1.9.0-0ubuntu1~cloud0"
swiftclient_version:        "1:1.5.0-0ubuntu1~cloud0"

hash_path_prefix:           changeme
hash_path_suffix:           changeme

object-expirer-host:        services1.demo
ring-master-host:           services1.demo

node_timeout:               60
conn_timeout:               2.5
object-replicator-timeout:  30

object-server-workers:      4
account-server-workers:     4
container-server-workers:   4

object-updater-workers:     1
object-replicator-workers:  2

mb_per_sync:                16
fallocate_reserve:          104857600
threads_per_disk:           4
object-server-log:          LOG_LOCAL1
container-server-log:       LOG_LOCAL1
account-server-log:         LOG_LOCAL1
jobs-log:                   LOG_LOCAL2

db-replicator_concurrency:  4
db-auditor_interval:        300
db-replicator_per_diff:     1000
account-reaper-delay:       604800

obj_allowed_headers:        "Content-Encoding, Content-Disposition, X-Object-Manifest, Access-Control-Allow-Origin, Access-Control-Allow-Credentials, Access-Control-Expose-Headers, Access-Control-Max-Age, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Origin, Access-Control-Request-Method, Access-Control-Request-Headers, X-Delete-At, X-Static-Large-Object, P3P"


allow_account_management:   "False"
db_preallocation:           off

object-expirer-log:         LOG_LOCAL2
object-expirer-log_level:   INFO
object-expirer-interval:    300
object-expirer-concurrency: 10
expirer_divisor:            3600

ring_master_ip:             123
