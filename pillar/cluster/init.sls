swift_version:              "1.9.0-0ubuntu1~cloud0"
swiftclient_version:        "1:1.5.0-0ubuntu1~cloud0"

hash_path_prefix:           HASH_PREFIX_CHANGEME
hash_path_suffix:           HASH_SUFFIX_CHANGEME

object-expirer-host:        services1.demo
ring-master-host:           services1.demo

memcache_servers:           10.179.198.231

node_timeout:               60
conn_timeout:               2.5
object-replicator-timeout:  30

object-server-workers:      4
account-server-workers:     4
container-server-workers:   4
proxy-server-workers:       8

object-updater-workers:     1
object-replicator-workers:  2

mb_per_sync:                16
fallocate_reserve:          104857600
threads_per_disk:           4
proxy-server-log:           LOG_LOCAL0
object-server-log:          LOG_LOCAL1
container-server-log:       LOG_LOCAL1
account-server-log:         LOG_LOCAL1
jobs-log:                   LOG_LOCAL2
sos-log:                    LOG_LOCAL3

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


proxy-bind-port:            80
trans_id_suffix:            "-demo"
container_limit:            65536
log_handoffs:               "true"

swauth:                     True
swauth_reseller_prefix:     SWAUTH
swauth_super_admin_key:     SUPER_ADMIN_KEY
swauth_swift_cluster:       "demo#https://swiftdemo.wwwdata.eu:443/v1#http://127.0.0.1:80/v1"

sos:                        True
sos_log_headers:            True
sos_conf:                   /etc/swift/sos.conf
origin_db_hosts:            cdn.wwwdata.eu
origin_cdn_host_suffixes:   demo.cdn.wwwdata.eu
origin_number_hash_id_containers:  10000
origin_max_ttl:                    2592000
origin_max_cdn_file_size:          1073741824
origin_admin_key:           ORIGIN_ADMIN_KEY
origin_hash_path_suffix:           ORIGIN_HASH_SUFFIX
origin_hmac_signed_url_secret:     ORIGIN_HMAC_SECRET


tempurl_methods:            "GET HEAD PUT DELETE"
account_ratelimit:          2000
# container_ratelimits:       False
container_ratelimits:       { 0: 100, 1000000: 50, 5000000: 10 }


