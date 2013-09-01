include:
  - core

swiftpkgs:
  pkg.installed:
    - skip_verify: True
    - pkgs:
        - python-greenlet
        - python-eventlet
        - python-swift: {{ pillar['swift_version'] }}
        - python-swiftclient: {{ pillar['swiftclient_version'] }}
        - swift: {{ pillar['swift_version'] }}
        - swift-doc: {{ pillar['swift_version'] }}
