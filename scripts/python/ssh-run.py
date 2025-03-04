#!/usr/bin/env python3

import paramiko

ssh_client = paramiko.SSHClient()

# To avoid an "unknown hosts" error. Solve this differently if you must...
ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# This mechanism uses a private key.
pkey = paramiko.RSAKey.from_private_key_file(PKEY_PATH)

# This mechanism uses a password.
# Get it from cli args or a file or hard code it, whatever works best for you
password = "password"

ssh_client.connect(hostname="my.host.name.com",
                       username="username",
                       # Uncomment one of the following...
                       # password=password
                       # pkey=pkey
                       )

# do something restricted
# If you don't need escalated permissions, omit everything before "mkdir"
command = "echo {} | sudo -S mkdir /var/log/test_dir 2>/dev/null".format(password)

# In order to inspect the exit code
# you need go under paramiko's hood a bit
# rather than just using "ssh_client.exec_command()"
chan = ssh_client.get_transport().open_session()
chan.exec_command(command)

exit_status = chan.recv_exit_status()

if exit_status != 0:
    stderr = chan.recv_stderr(5000)

# Note that sudo's "-S" flag will send the password prompt to stderr
# so you will see that string here too, as well as the actual error.
# It was because of this behavior that we needed access to the exit code
# to assert success.

    logger.error("Uh oh")
    logger.error(stderr)
else:
    logger.info("Successful!")
