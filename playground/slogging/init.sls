slogging:
  git.latest:
    - name: https://github.com/notmyname/slogging.git
    - target: /usr/src/slogging
    - rev: master

Run install-slogging:
  cmd.wait:
    - name: python setup.py install
    - cwd: /usr/src/slogging
    - watch:
      - git: slogging
