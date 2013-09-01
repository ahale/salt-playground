include:
  - core.repo

corepkgs:
  pkg.installed:
    - order: 2
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