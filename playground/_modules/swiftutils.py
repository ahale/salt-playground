'''
Simple modules with various utils
'''

HAS_SWIFTUTILS = False
try:
    import netifaces
    import logging
    import salt
    from os import listdir
    from os.path import isfile, join
    from swift import __version__ as swiftversion
    from swift.common.constraints import check_mount
    from swift.common.utils import whataremyips
    from swift.common.ring import Ring

    HAS_SWIFTUTILS = 'swiftutils'
except ImportError:
    HAS_SWIFTUTILS = False

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


def get_disks(path='/mnt/'):
    disks = [f.rstrip('.disk') for f in listdir(path) if isfile(join(path, f))]
    return disks
