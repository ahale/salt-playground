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
  '{{ pillar['object-expirer-host'] }}':
    - match: glob
    - object-expirer
