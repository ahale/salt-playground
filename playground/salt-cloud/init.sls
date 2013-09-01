salt-cloud:
  pkg:
    - installed

/etc/salt/cloud:
  file.managed:
    - source: salt://etc/salt/cloud
    - user: root
    - group: root
    - mode: 600
    - template: jinja

/etc/salt/cloud.profiles:
  file.managed:
    - source: salt://etc/salt/cloud.profiles
    - user: root
    - group: root
    - mode: 644

/etc/salt/mapfiles/swiftdemo:
  file.managed:
    - source: salt://etc/salt/mapfiles/swiftdemo
    - user: root
    - group: root
    - mode: 644
    - template: jinja
