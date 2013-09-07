include:
  - core.repo

swift-account:
  pkg.installed:
    - skip_verify: True
    - require:
      - pkgrepo: ubuntu_cloud_repo
  service:
    - running
    - sig: swift-account-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-account
      - file: /etc/swift/account-server.conf
      - service: swift-ring-minion
    - watch:
      - file: /etc/swift/account-server.conf

/etc/swift/account-server.conf:
  file.managed:
    - source: salt://etc/swift/account-server.conf
    - mode: 644
    - template: jinja
