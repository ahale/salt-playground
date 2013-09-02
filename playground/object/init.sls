include:
  - core.repo

xfsprogs:
  pkg.installed

swift-object:
  pkg.installed:
    - skip_verify: True
    - require:
      - pkgrepo: ubuntu_cloud_repo

/etc/swift/object-server.conf:
  file.managed:
    - source: salt://etc/swift/object-server.conf
    - mode: 644
    - template: jinja

{% for disk in pillar['loopback_devices'] -%}
{{ disk }}:
  loopbackdisk.xfs:
    - mount: {{ disk }}
    - require:
      - pkg: xfsprogs

/srv/node/{{ disk }}:
  mount.mounted:
    - device: /mnt/{{ disk }}.disk
    - fstype: xfs
    - opts: loop,noatime,nodiratime,nobarrier,logbufs=8
    - mkmnt: True

{% endfor -%}
        