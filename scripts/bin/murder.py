#!/usr/bin/env python3
import os
import sys
import signal
import subprocess
import time
from shlex import split

# TODO: add description

# Signals to try: [(signal_number, wait_seconds_after)]
SIGNALS = [
    (signal.SIGTERM, 3),
    (signal.SIGINT, 3),
    (signal.SIGHUP, 4),
    (signal.SIGKILL, 0)
]

def is_pid(arg):
    return arg.isdigit()

def is_port(arg):
    return arg.startswith(':') and arg[1:].isdigit()

def running(pid):
    try:
        os.kill(pid, 0)
        return True
    except OSError:
        return False

def go_ahead(prompt):
    answer = input(prompt).strip().lower()
    return answer in ('y', 'yes', 'ye')

def murder_pid(pid):
    pid = int(pid)
    for sig, wait in SIGNALS:
        if not running(pid):
            break
        os.kill(pid, sig)
        time.sleep(0.5)
        if running(pid) and wait > 0:
            time.sleep(wait)

def murder_names(name):
    while True:
        should_loop = False
        # Get running processes matching name
        try:
            output = subprocess.check_output(
                ["ps", "-eo", "pid,command"], text=True
            )
        except subprocess.CalledProcessError:
            break
        lines = [l for l in output.splitlines() if name.lower() in l.lower() and "grep" not in l]
        for line in lines:
            pid_str, fullname = line.strip().split(None, 1)
            pid = int(pid_str)
            if pid == os.getpid():
                continue
            if go_ahead(f"Murder {fullname} (pid {pid})? "):
                murder_pid(pid)
                should_loop = True
                break
        if not should_loop:
            break

def murder_port(port_arg):
    port = port_arg[1:]
    while True:
        should_loop = False
        try:
            lsof_out = subprocess.check_output(["lsof", "-i", port], text=True)
        except subprocess.CalledProcessError:
            break
        lines = lsof_out.splitlines()[1:]
        for line in lines:
            parts = line.split()
            if len(parts) < 2:
                continue
            pid = int(parts[1])
            try:
                fullname = subprocess.check_output(["ps", "-p", str(pid), "-o", "command="], text=True).strip()
            except subprocess.CalledProcessError:
                continue
            if go_ahead(f"Murder {fullname} (pid {pid})[Y/N]? "):
                murder_pid(pid)
                should_loop = True
                break
        if not should_loop:
            break

def murder(arg):
    if is_pid(arg):
        murder_pid(arg)
    elif is_port(arg):
        murder_port(arg)
    else:
        murder_names(arg)

def main():
    if len(sys.argv) < 2:
        print("usage:")
        print("murder 123    # kill by pid")
        print("murder python # kill by process name")
        print("murder :3000  # kill by port")
        sys.exit(1)

    for arg in sys.argv[1:]:
        murder(arg)

if __name__ == "__main__":
    main()
