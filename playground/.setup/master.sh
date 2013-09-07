#!/bin/bash

function getrand() { < /dev/urandom tr -dc A-Za-z0-9 | head -c16 ; }

echo ''
read -p 'rackspace username: ' USER
read -p 'rackspace password: ' PASS
read -p 'rackspace tenant: ' TENANT
echo ''
echo 'generating swift hash prefix'
PREFIX=$(getrand)
SUFFIX=$(getrand)
SUPER_ADMIN_KEY=$(getrand)

sed -i "s/RACKSPACE_USER/$USER/" /srv/salt/pillar/cloud/init.sls
sed -i "s/RACKSPACE_PASS/$PASS/" /srv/salt/pillar/cloud/init.sls
sed -i "s/RACKSPACE_TENANT/$TENANT/" /srv/salt/pillar/cloud/init.sls

sed -i "s/HASH_PREFIX_CHANGEME/$PREFIX/" /srv/salt/pillar/cluster/init.sls
sed -i "s/HASH_SUFFIX_CHANGEME/$SUFFIX/" /srv/salt/pillar/cluster/init.sls
sed -i "s/SUPER_ADMIN_KEY/$SUPER_ADMIN_KEY/" /srv/salt/fileserver/etc/swift/proxy-server.conf

apt-get update
apt-get install python-software-properties -y --force-yes
add-apt-repository ppa:saltstack/salt
apt-get update
apt-get install salt-master salt-cloud salt-minion -y --force-yes

MASTER=$(hostname -i | grep -oE '10[.0-9]*' | head -n1)
CONF="/etc/salt/master"
echo "interface: $MASTER" > $CONF
echo "peer:" > $CONF
echo "  .*:" >> $CONF
echo "    - grains.item" >> $CONF
echo "    - swiftutils.get_disks" >> $CONF
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
echo "master: ${MASTER}" > $CONF
echo "grains:" >> $CONF
echo "  roles:" >> $CONF
echo "    - salt-cloud" >> $CONF

/etc/init.d/salt-master restart
/etc/init.d/salt-minion restart
