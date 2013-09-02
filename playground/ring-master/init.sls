include:
  - ring-master.git

/etc/swift/ring-master.conf:
  file.managed:
    - source: salt://etc/swift/ring-master.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/var/log/ring-master:
  file.directory:
    - makedirs: True
    - user: swift
    - group: swift


/etc/init.d/swift-ring-master-server:
  file.managed:
    - source: salt://etc/init.d/swift-ring-master
    - user: root
    - group: root
    - mode: 755

/etc/init.d/swift-ring-master-wsgi:
  file.managed:
    - source: salt://etc/init.d/swift-ring-master-wsgi
    - user: root
    - group: root
    - mode: 755

swift-ring-master-server:
  service:
    - running
    - sig: swift-ring-master-server
    - enable: True
    - require:
      - git: swift-ring-master
      - file: /etc/swift/ring-master.conf
    - watch:
      - file: /etc/init.d/swift-ring-master-server

swift-ring-master-wsgi:
  service:
    - running
    - sig: swift-ring-master-wsgi-server
    - enable: True
    - require:
      - git: swift-ring-master
      - file: /etc/swift/ring-master.conf
    - watch:
      - file: /etc/init.d/swift-ring-master-wsgi
