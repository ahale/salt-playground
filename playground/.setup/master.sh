#!/bin/bash

apt-get update
apt-get install python-software-properties -y --force-yes
add-apt-repository ppa:saltstack/salt
apt-get update
apt-get install salt-master salt-cloud salt-minion -y --force-yes

CONF="/etc/salt/master"
echo "interface: $MASTER" > $CONF
echo "peer:" > $CONF
echo "  .*:" >> $CONF
echo "    - grains.item" >> $CONF
echo "" >> $CONF
echo "file_roots:" >> $CONF
echo "  base:" >> $CONF
echo "    - /srv/salt/playground" >> $CONF
echo "    - /srv/salt/fileserver" >> $CONF
echo "" >> $CONF
echo "pillar_roots:" >> $CONF
echo "  base:" >> $CONF
echo "    - /srv/salt/pillar" >> $CONF


CONF="/etc/salt/minion"
MASTER=$(hostname -i | grep -oE '10[.0-9]*')
echo "master: ${MASTER}" > $CONF

/etc/init.d/salt-master restart
/etc/init.d/salt-minion restart