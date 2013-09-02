include:
  - core.repo

swift-account:
  pkg.installed:
    - skip_verify: True
    - require:
      - pkgrepo: ubuntu_cloud_repo

/etc/swift/account-server.conf:
  file.managed:
    - source: salt://etc/swift/account-server.conf
    - mode: 644
    - template: jinja
