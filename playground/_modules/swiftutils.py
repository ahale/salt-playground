'''
Simple modules with various utils
'''

HAS_SWIFTUTILS = False
try:
    from swift import __version__ as swiftversion
    from swift.common.constraints import check_mount
    from swift.common.utils import whataremyips
    from swift.common.ring import Ring
    import netifaces
    HAS_SWIFTUTILS = 'swiftutils'
except ImportError:
    HAS_SWIFTUTILS = False

import logging
import subprocess
import salt

from subprocess import PIPE
from os import listdir
from os.path import isfile, join


log = logging.getLogger(__name__)


def __virtual__():
    return HAS_SWIFTUTILS


def _in_ring(ring):
    """
    returns whether any local ips present in a given ring file
    """
    in_ring = False
    my_ips = whataremyips()
    for dev in ring.devs:
        try:
            if dev['ip'] in my_ips and float(dev['weight']) > 0:
                in_ring = True
        except TypeError:
            pass
    return in_ring


def rings():
    """
    Return a list of swift rings that the minion has >0 weight drives in.
    """
    res = []
    my_ips = whataremyips()
    rinfo = {'account': {'ringfile': '/etc/swift/account.ring.gz', 'in_ring': False},
             'container': {'ringfile': '/etc/swift/container.ring.gz', 'in_ring': False},
             'object': {'ringfile': '/etc/swift/object.ring.gz', 'in_ring': False}}
    for r in rinfo:
        ring = Ring(rinfo[r]['ringfile'])
        if _in_ring(ring):
            res.append(r)
    return res


def _ips(prefix=None):
    """
    Return a list of ips
    """
    if has_ifaces:
        addresses = []
        for interface in netifaces.interfaces():
            try:
                iface_data = netifaces.ifaddresses(interface)
                for family in iface_data:
                    if family not in (netifaces.AF_INET, netifaces.AF_INET6):
                        continue
                    for address in iface_data[family]:
                        if prefix:
                            if address['addr'].startswith(str(prefix)):
                                addresses.append(address['addr'])
                        else:
                            addresses.append(address['addr'])
            except ValueError:
                pass
        return addresses
    else:
        log.error('python netifaces not present!')
        return []


def ips_with_prefix(prefix):
    """
    Get the machine's ips that start with prefix

    CLI Example::
        salt '*' swiftutils.ips_with_prefix 192.
    """
    return _ips(str(prefix))


def get_disks(mountdir='/mnt/'):
    disks = [ f.rstrip('.disk') for f in listdir(mountdir) if isfile(join(mountdir,f)) ]
    return disks



