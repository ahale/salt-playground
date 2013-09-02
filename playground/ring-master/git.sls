swift-ring-master:
  git.latest:
    - name: https://github.com/pandemicsyn/swift-ring-master.git
    - target: /usr/src/swift-ring-master
    - rev: master

Run install-ring-master:
  cmd.wait:
    - name: python setup.py install
    - cwd: /usr/src/swift-ring-master
    - watch:
      - git: swift-ring-master
