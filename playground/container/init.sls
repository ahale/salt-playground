include:
  - core.repo

swift-container:
  pkg.installed:
    - skip_verify: True
    - require:
      - pkgrepo: ubuntu_cloud_repo
  service:
    - running
    - sig: swift-container-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-container
      - file: /etc/swift/container-server.conf
      - service: swift-ring-minion
    - watch:
      - file: /etc/swift/container-server.conf


/etc/swift/container-server.conf:
  file.managed:
    - source: salt://etc/swift/container-server.conf
    - mode: 644
    - template: jinja

