/etc/swift/object-expirer.conf:
  file.managed:
    - source: salt://etc/swift/object-expirer.conf
    - mode: 644
    - template: jinja
