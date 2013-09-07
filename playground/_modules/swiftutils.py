# Copyright (c) 2010-2012 OpenStack, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.


EXIT_SUCCESS = 0
EXIT_WARNING = 1
EXIT_ERROR = 2

HAS_SWIFTUTILS = False
try:
    import os
    import netifaces
    import logging
    import salt
    from os import listdir
    from os.path import isfile, join
    from swift import __version__ as swiftversion
    from swift.common.constraints import check_mount as _check_mount
    from swift.common.utils import whataremyips as _whataremyips
    from swift.common.ring import Ring
    from swift.common.ring import RingBuilder

    HAS_SWIFTUTILS = 'swiftutils'
except ImportError:
    HAS_SWIFTUTILS = False

log = logging.getLogger(__name__)


def __virtual__():
    return HAS_SWIFTUTILS


def _in_ring(service):
    """
    returns whether any local ips present in a given ring file
    """
    in_ring = False
    try:
        ringfile = '/etc/swift/%s.ring.gz' % service
        ring = Ring(ringfile)
    except IOError:
        return in_ring

    my_ips = _whataremyips()
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


def _parse_add_values(devstr, weightstr):
    parsed_devs = []
    region = 1
    rest = devstr
    if devstr.startswith('r'):
        i = 1
        while i < len(devstr) and devstr[i].isdigit():
            i += 1
        region = int(devstr[1:i])
        rest = devstr[i:]
    else:
        stderr.write("WARNING: No region specified for %s. "
                     "Defaulting to region 1.\n" % devstr)

    if not rest.startswith('z'):
        print 'Invalid add value: %s' % devstr
        exit(EXIT_ERROR)
    i = 1
    while i < len(rest) and rest[i].isdigit():
        i += 1
    zone = int(rest[1:i])
    rest = rest[i:]

    if not rest.startswith('-'):
        print 'Invalid add value: %s' % devstr
        print "The on-disk ring builder is unchanged.\n"
        exit(EXIT_ERROR)
    i = 1
    if rest[i] == '[':
        i += 1
        while i < len(rest) and rest[i] != ']':
            i += 1
        i += 1
        ip = rest[1:i].lstrip('[').rstrip(']')
        rest = rest[i:]
    else:
        while i < len(rest) and rest[i] in '0123456789.':
            i += 1
        ip = rest[1:i]
        rest = rest[i:]

    if not rest.startswith(':'):
        print 'Invalid add value: %s' % devstr
        print "The on-disk ring builder is unchanged.\n"
        exit(EXIT_ERROR)
    i = 1
    while i < len(rest) and rest[i].isdigit():
        i += 1
    port = int(rest[1:i])
    rest = rest[i:]

    replication_ip = ip
    replication_port = port
    if rest.startswith('R'):
        i = 1
        if rest[i] == '[':
            i += 1
            while i < len(rest) and rest[i] != ']':
                i += 1
            i += 1
            replication_ip = rest[1:i].lstrip('[').rstrip(']')
            rest = rest[i:]
        else:
            while i < len(rest) and rest[i] in '0123456789.':
                i += 1
            replication_ip = rest[1:i]
            rest = rest[i:]

        if not rest.startswith(':'):
            print 'Invalid add value: %s' % devstr
            print "The on-disk ring builder is unchanged.\n"
            exit(EXIT_ERROR)
        i = 1
        while i < len(rest) and rest[i].isdigit():
            i += 1
        replication_port = int(rest[1:i])
        rest = rest[i:]

    if not rest.startswith('/'):
        print 'Invalid add value: %s' % devstr
        print "The on-disk ring builder is unchanged.\n"
        exit(EXIT_ERROR)
    i = 1
    while i < len(rest) and rest[i] != '_':
        i += 1
    device_name = rest[1:i]
    rest = rest[i:]

    meta = ''
    if rest.startswith('_'):
        meta = rest[1:]

    try:
        weight = float(weightstr)
    except ValueError:
        print 'Invalid weight value: %s' % weightstr
        print "The on-disk ring builder is unchanged.\n"
        exit(EXIT_ERROR)

    if weight < 0:
        print 'Invalid weight value (must be positive): %s' % weightstr
        print "The on-disk ring builder is unchanged.\n"
        exit(EXIT_ERROR)

    parsed_devs.append({'region': region, 'zone': zone, 'ip': ip,
                        'port': port, 'device': device_name,
                        'replication_ip': replication_ip,
                        'replication_port': replication_port,
                        'weight': weight, 'meta': meta})
    return parsed_devs


def _get_builder_strings(service, drivelist, iface='eth1', hostglob='storage*'):
    ports = {"object": 6000, "container": 6001, "account": 6002}
    builder_strings = []
    ip_list = []
    caller = salt.client.Caller()
    ipinfo = caller.function('publish.publish',
                             hostglob, 'grains.item',
                             'ip_interfaces')
    for host in ipinfo:
        hostname = host.split('.')[0]
        zone = hostname.split('-')[1].lstrip('Z')
        ip = ipinfo[host]['ip_interfaces'][iface][0]
        if drivelist:
            drives = {}
            drives[host] = drivelist
        drives = caller.function('publish.publish', host,
                                 'swiftutils.get_disks')
        for drive in drives[host]:
            hoststr = 'r1z%s-%s:%s/%s1' % (zone, ip, ports[service], drive)
            builder_strings.append(hoststr)
    return builder_strings


def remake_rings(partpower=16, weight=100, replicas=3, min_part_hours=1, drives=False):
    for service in ['object', 'container', 'account']:
        builder_file = '/etc/swift/%s.builder' % service
        ring_file = '/etc/swift/%s.ring.gz' % service
        try:
            os.remove(builder_file)
            os.remove(ring_file)
        except OSError:
            pass
        builder = RingBuilder(partpower, replicas, min_part_hours)
        builder.save(builder_file)
        devstrs = _get_builder_strings(service, drives)
        for devstr in devstrs:
            new_dev = _parse_add_values(devstr, str(weight))
            builder.add_dev(new_dev[0])
        builder.save(builder_file)
        builder.rebalance(builder_file)
        builder.get_ring().save(ring_file)

