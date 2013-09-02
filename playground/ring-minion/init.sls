include:
  - ring-master.git

/etc/swift/ring-minion.conf:
  file.managed:
    - source: salt://etc/swift/ring-minion.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/init.d/swift-ring-minion:
  file.managed:
    - source: salt://etc/init.d/swift-ring-minion
    - user: root
    - group: root
    - mode: 755

swift-ring-minion:
  service:
    - running
    - sig: swift-ring-minion-server
    - enable: True
    - require:
      - git: swift-ring-master
      - file: /etc/swift/ring-minion.conf
    - watch:
      - file: /etc/init.d/swift-ring-minion
