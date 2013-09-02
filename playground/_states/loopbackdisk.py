
import os
import subprocess
from subprocess import PIPE


def _run_cmd(cmd):
    """
    Run a command
    """
    proc = subprocess.Popen(cmd, stdout=PIPE)
    data = proc.communicate()[0]
    return data


def xfs(mount, size="1G", path="/mnt/", force=False):
    ret = {'name': mount,
           'changes': {},
           'result': True,
           'comment': ''}

    try:
        root_dev = os.stat('/srv/node')[2]
        mount_dev = os.stat('/srv/node/%s' % mount)[2]
        disk_file = os.stat('/srv/node/%s.disk' % mount)
    except OSError:
        pass

    if not force:
        try:
            if disk_file:
                ret['result'] = False
                ret['comment'] = 'disk file already exists, use force to overwrite'
                return ret
        except NameError:
            pass
    try:
        if mount_dev != root_dev:
            ret['result'] = False
            ret['comment'] = 'device mounted'
            return ret
    except NameError:
        pass
    
    filename = path + mount + '.disk'
    try:
        _run_cmd(['truncate', '-s', size, filename])
        _run_cmd(['mkfs.xfs', '-f', '-L', mount, filename])
        ret['comment'] = _run_cmd(['ls', filename])
        return ret
    except:
        ret['result'] = False
        return ret
