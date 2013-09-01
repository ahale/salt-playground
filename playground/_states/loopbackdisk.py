
import subprocess
from subprocess import PIPE


def _run_cmd(cmd):
    """
    Run a command
    """
    proc = subprocess.Popen(cmd, stdout=PIPE)
    data = proc.communicate()[0]
    return data


def xfs(mount, size="1G", path="/mnt/"):

    ret = {'name': mount,
           'changes': {},
           'result': True,
           'comment': ''}

    filename = path + mount + '.disk'
    try:
        _run_cmd(['truncate', '-s', size, filename])
        _run_cmd(['mkfs.xfs', '-f', '-L', mount, filename])
        ret['comment'] = _run_cmd(['ls', filename])
        return ret
    except:
        ret['result'] = False
        return ret
