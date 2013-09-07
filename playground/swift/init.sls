include:
  - core

/etc/swift:
  file.directory:
    - makedirs: True
    - owner: swift
    - group: swift
    - mode: 755
    - require:
      - pkg: swiftpkgs

/etc/swift/swift.conf:
  file.managed:
    - source: salt://etc/swift/swift.conf
    - mode: 644
    - template: jinja
    - require: 
      - file: /etc/swift

/var/run/swift:
  file.directory:
    - makedirs: True
    - mode: 777
    - require: 
      - pkg: swiftpkgs

/var/log/swift:
  file.directory:
    - makedirs: True
    - mode: 755
    - require: 
      - pkg: swiftpkgs

swiftpkgs:
  pkg.installed:
    - require:
        - pkg: corepkgs
    - skip_verify: True
    - pkgs:
        - python-greenlet
        - python-eventlet
        - python-swift: {{ pillar['swift_version'] }}
        - python-swiftclient: {{ pillar['swiftclient_version'] }}
        - swift: {{ pillar['swift_version'] }}
        - swift-doc: {{ pillar['swift_version'] }}
  pip.installed:
    - name: dnspython
    - options: dnspython>=1.10.0
    - require:
        - pkg: corepkgs

