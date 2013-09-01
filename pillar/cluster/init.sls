swift_version:              "1.9.0-0ubuntu1~cloud0"
swiftclient_version:        "1:1.5.0-0ubuntu1~cloud0"

proxy-server-node_timeout:  60
proxy-server-conn_timeout:  2.5
proxy-server-allow_account_management: "False"


object-expirer-host:        services1.demo
object-expirer-log:         LOG_LOCAL2
object-expirer-log_level:   INFO
object-expirer-pipeline:    "catch_errors cache proxy-logging proxy-server"
object-expirer-interval:    300
object-expirer-concurrency: 10
