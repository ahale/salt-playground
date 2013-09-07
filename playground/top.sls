base:
  '*':
    - core
  'roles:salt-cloud':
    - match: grain
    - salt-cloud
  'cluster:{{ pillar['swiftdemo_domain'] }}':
    - match: grain
    - swift
  'storage*':
    - match: glob
    - object
    - container
    - account
    - rsyncd
    - ring-minion
  'proxy*':
    - match: glob
    - proxy
    - swauth
    - sos
    - ring-minion
  '{{ pillar['object-expirer-host'] }}':
    - match: glob
    - object-expirer
  '{{ pillar['ring-master-host'] }}':
    - match: glob
    - ring-master
