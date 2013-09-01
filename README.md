salt-playground
===============

This is a saltstack environment for building an Openstack Swift test multi server cluster in the Rackspace Cloud using salt-cloud to provision virtual machines. 

All configuration for the cluster is set in the salt pillar init file. The number of zones, servers per zone, drives per server as well as number of proxy and services servers are defined by the options starting `swiftdemo` and API credentials for the Rackspace Cloud should be configured and kept secret. Salt generates the mapfile and credentials files for salt-cloud using these files. The swift cluster currently only utilises XFS loopback filesystems.

First build a server to work from and clone the repo then configure the salt-master

    root@admin1:~# apt-get install git
    root@admin1:~# git clone https://github.com/ahale/salt-playground.git /srv/salt
    root@admin1:~# vi /srv/salt/pillar/cloud/init.sls
    root@admin1:~# /srv/salt/playground/.setup/master.sh
    root@admin1:~# salt-key -L
    Accepted Keys:
    Unaccepted Keys:
    admin1
    Rejected Keys:
    root@admin1:~# salt-key -a admin1
    root@admin1:~# salt '*' state.highstate

Now build the cluster. This takes a few minutes and returns information about our minions. Test that the cluster looks as expected with `salt -G 'cluster:demo' test.ping` command once its complete.

    root@salt-playground:~# salt-cloud -m /etc/salt/mapfiles/swiftdemo -P
    root@salt-playground:~# salt -G 'cluster:demo' test.ping

Now deploy the firewall to each node, this is a horrible misuse of salt publish module which lets each minion gather all the other minions servicenet ip address to create an iptables configuration. Since it makes a lot of salt calls to complete its worth just running it when adding new nodes.

    root@salt-playground:~# salt -G 'cluster:demo' state.sls firewall test=True
    root@salt-playground:~# salt -G 'cluster:demo' state.sls firewall

Then finally deploy the cluster.

    root@salt-playground:~# salt -G 'cluster:demo' state.highstate

