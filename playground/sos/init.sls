/etc/swift/sos.conf:
  file.managed:
    - source: salt://etc/swift/sos.conf
    - mode: 644
    - template: jinja

sos:
  git.latest:
    - name: https://github.com/dpgoetz/sos.git
    - target: /usr/src/sos
    - rev: master

Run install-sos:
  cmd.wait:
    - name: python setup.py install
    - cwd: /usr/src/sos
    - watch:
      - git: sos
