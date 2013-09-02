include:
  - core.repo

corepkgs:
  pkg.installed:
    - order: 1
    - skip_verify: True
    - pkgs:
        - ubuntu-cloud-keyring
        - curl
        - gcc
        - git-core
        - python-setuptools
        - python-pip
        - parted
        - ipython
        - python-dev
