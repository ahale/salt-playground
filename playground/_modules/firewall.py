import salt


def __virtual__():
    return 'firewall'


def get_ips(iface='eth1'):
    """
    Return list of all minion private ips

    CLI Example::
        salt '*' firewall.get_firewall_ips
    """
    ip_list = []
    caller = salt.client.Caller()
    ip_info = caller.function('publish.publish', '*', 'grains.item', 'ip_interfaces')
    for host in ip_info:
        ip_list.append(ip_info[host]['ip_interfaces'][iface][0])
    return ip_list
