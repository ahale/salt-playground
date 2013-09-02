include:
  - core.repo

swift-container:
  pkg.installed:
    - skip_verify: True
    - require:
      - pkgrepo: ubuntu_cloud_repo

/etc/swift/container-server.conf:
  file.managed:
    - source: salt://etc/swift/container-server.conf
    - mode: 644
    - template: jinja
