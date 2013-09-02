include:
  - core

/etc/swift/:
  file.directory:
    - makedirs: True
    - owner: swift
    - group: swift
    - mode: 755

/etc/swift/swift.conf:
  file.managed:
    - source: salt://etc/swift/swift.conf
    - mode: 644
    - template: jinja

/var/run/swift:
  file.directory:
    - makedirs: True
    - mode: 777

swiftpkgs:
  pkg.installed:
    - order: 3
    - skip_verify: True
    - pkgs:
        - python-greenlet
        - python-eventlet
        - python-swift: {{ pillar['swift_version'] }}
        - python-swiftclient: {{ pillar['swiftclient_version'] }}
        - swift: {{ pillar['swift_version'] }}
        - swift-doc: {{ pillar['swift_version'] }}
