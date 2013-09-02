iptables-persistent:
  pkg.installed:
    - name: iptables-persistent
  file.managed:
    - name: /etc/iptables/rules.v4
    - source: salt://etc/iptables/rules
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: iptables-persistent
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/iptables/rules.v4
    - require:
      - pkg: iptables-persistent
