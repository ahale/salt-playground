import os
import salt
from swift.common.ring import Ring


def ensure_ring(path='/etc/swift'):
    ringfiles = ['object', 'container', 'account']
    ret = {'name': 'ensure_ring',
           'changes': {},
           'result': True,
           'comment': ''}
    for ring in ringfiles:
        ringfile = '%s/%s.ring.gz' % (path, ring)
        try:
            r = Ring(ringfile)
        except IOError:
            try:
                caller = salt.client.Caller()
                caller.function('swiftutils.remake_rings')
                ret['comment'] = 'initialising rings'
            except:
                ret['result'] = False
                ret['comment'] = 'error initialising rings'
            return ret
        ret['comment'] = 'rings look good'
        return ret
