swauth:
  git.latest:
    - name: https://github.com/gholt/swauth.git
    - target: /usr/src/swauth
    - rev: master

Run install-swauth:
  cmd.wait:
    - name: python setup.py install
    - cwd: /usr/src/swauth
    - watch:
      - git: swauth
