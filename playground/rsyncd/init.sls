rsyncpkgs: 
  pkg.installed: 
    - skip_verify: True 
    - pkgs: 
        - rsync

/etc/rsyncd.conf:
  file.managed:
    - source: salt://etc/rsyncd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/default/rsync:
  file.managed:
    - source: salt://etc/default/rsync
    - user: root
    - group: root
    - mode: 644

rsync:
  service:
    - running
    - enable: True
    - sig: "/usr/bin/rsync --no-detach --daemon"
