include:
  - core.repo
  - ring-minion

/etc/swift/proxy-server.conf:
  file.managed:
    - source: salt://etc/swift/proxy-server.conf
    - mode: 644
    - template: jinja

/etc/swift/memcache.conf:
  file.managed:
    - source: salt://etc/swift/memcache.conf
    - mode: 644
    - template: jinja

memcached:
  file.managed:
    - name: /etc/memcached.conf
    - source: salt://etc/memcached.conf
    - template: jinja
  pkg.installed:
    - skip_verify: True
  service:
    - running
    - enable: True
    - reload: True
    - require:
      - pkg: memcached
      - file: /etc/memcached.conf
    - watch:
      - file: /etc/memcached.conf

swift-proxy:
  pkg.installed:
    - skip_verify: True
    - require:
      - pkgrepo: ubuntu_cloud_repo
  service:
    - running
    - sig: swift-proxy-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-proxy
      - pkg: memcached
      - file: /etc/swift/proxy-server.conf
      - file: /etc/swift/memcache.conf
      - service: swift-ring-minion
    - watch:
      - file: /etc/swift/proxy-server.conf
      - file: /etc/swift/memcache.conf
