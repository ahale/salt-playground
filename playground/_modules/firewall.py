import salt


__virtualname__ = 'firewall'


def get_ips(iface='eth1', hostglob='*'):
    """
    Return list of all minion private ips

    CLI Example::
        salt '*' firewall.get_ips
    """
    ip_list = []
    caller = salt.client.Caller()
    ipinfo = caller.function('publish.publish', hostglob, 'grains.item', 'ip_interfaces')
    for host in ipinfo:
        ip_list.append(ipinfo[host]['ip_interfaces'][iface][0])
    return ip_list
