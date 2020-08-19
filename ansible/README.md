## Squid deployment and configuration ansible playbook on MS Azure VM

### Requirements
- Linux environment (tested with Ubuntu 18.04 LTS and Manjaro Linux 20)
- curl
- Python 3.6 or 3.7 (virtualenv is fine)
- ansible and ansible azure modules
- a X.509 certificate authority with  private key included (RSA 2048 Bit or higher recommended)
- [az](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

### Preparing dependencies
1. Install Python 3.6 or 3.7 this can be done using the package manager of your distribution or by installing python manually from python.org, you can make use of open source tools like [pyenv](https://github.com/pyenv/pyenv)

2. Install curl using your distribution package manager
3. Install az

```bash
curl -L https://aka.ms/InstallAzureCli | bash # Install az
#   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
#                                  Dload  Upload   Total   Spent    Left  Speed
#   0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
# 100  1405  100  1405    0     0    361      0  0:00:03  0:00:03 --:--:--   827
# Downloading Azure CLI install script from https://azurecliprod.blob.core.windows.net/install.py to /tmp/azure_cli_install_tmp_A2PRQ1.
# ######################################################################## 100.0%
# /tmp/azure_cli_install_tmp_A2PRQ1: OK
# Running install script.
# -- Verifying Python version.
# -- Python version 3.7.9 okay.
# -- Verifying native dependencies.
# -- Unable to verify native dependencies. dist=manjaro linux, version=None. Continuing...
# 
# ===> In what directory would you like to place the install? (leave blank to use '/home/user/lib/azure-cli'): 
# -- Creating directory '/home/user/lib/azure-cli'.
# -- We will install at '/home/user/lib/azure-cli'.
# 
# ===> In what directory would you like to place the 'az' executable? (leave blank to use '/home/user/bin'): 
# -- Creating directory '/home/user/bin'.
# -- The executable will be in '/home/user/bin'.
# -- Downloading virtualenv package from https://pypi.python.org/packages/source/v/virtualenv/virtualenv-16.7.7.tar.gz.
# -- Downloaded virtualenv package to /tmp/tmpkapw2xq0/virtualenv-16.7.7.tar.gz.
# -- Checksum of /tmp/tmpkapw2xq0/virtualenv-16.7.7.tar.gz OK.
# -- Extracting '/tmp/tmpkapw2xq0/virtualenv-16.7.7.tar.gz' to '/tmp/tmpkapw2xq0'.
# -- Executing: ['/usr/bin/python3', 'virtualenv.py', '--python', '/usr/bin/python3', '/home/user/lib/azure-cli']
# Already using interpreter /usr/bin/python3
# Using base prefix '/usr'
# New python executable in /home/user/lib/azure-cli/bin/python3
# Also creating executable in /home/user/lib/azure-cli/bin/python
# Installing setuptools, pip, wheel...
# done.
# -- Executing: ['/home/user/lib/azure-cli/bin/pip', 'install', '--cache-dir', '/tmp/tmpkapw2xq0', 'azure-cli', '--upgrade']
# Collecting azure-cli
#   Downloading azure_cli-2.10.1-py3-none-any.whl (1.7 MB)
#      |████████████████████████████████| 1.7 MB 585 kB/s 
# 
# ...
# ...
# ...
# 
# -- The executable is available at '/home/user/bin/az'.
# -- Created tab completion file at '/home/user/lib/azure-cli/az.completion'
# 
# ===> Modify profile to update your $PATH and enable shell/tab completion now? (Y/n):y
# 
# ===> Could not automatically find a suitable file to use. Create /home/user/.bashrc now? (Y/n): y
# -- Backed up '/home/user/.bashrc' to '/home/user/.bashrc.backup'
# -- Tab completion set up complete.
# -- If tab completion is not activated, verify that '/home/user/.bashrc' is sourced by your shell.
# -- 
# -- ** Run `exec -l $SHELL` to restart your shell. **
# -- 
# -- Installation successful.
# -- Run the CLI with /home/user/bin/az --help
# 
```

4. If you are using a python virtual environment, you should activate it then execute `pip3 install ansible[azure]` , otherwise you can execute the following

```bash
grep -e "$HOME/.local/bin" -e '$HOME/.local/bin' <(echo $PATH) || eval $(echo 'export PATH=$PATH:$HOME/.local/bin' | tee -a ~/.bashrc)
pip3 install --user ansible[azure]
```

5. Create certificate authority at squid.pem (or copy your CA to squid.pem), theres a dummy CA in squid.pem for testing purposes

```bash
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout squid.pem -out squid.pem
# Generating a RSA private key
# ..................................................................+++++
# .............................................+++++
# writing new private key to 'squid.pem'
# -----
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) [AU]:UK
# State or Province Name (full name) [Some-State]:
# Locality Name (eg, city) []:
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:Glasswall Solutions Limited
# Organizational Unit Name (eg, section) []:
# Common Name (e.g. server FQDN or YOUR name) []:glasswallsolutions.com
# Email Address []:
```

6. Login to azure with az command 

```bash
az login
```

### Usage
1. Tweak configuration in config_vars.yaml to meet preferences, replace the example ssh public key with your ssh public key.

   If you do not already have SSH key pairs, you can use `ssh-keygen` command

2. Optionally, tweak squid.conf.j2 template file (i.e to tweak target squid.conf)

3. execute the following command and replace `<ssh private key path>` with the path to your ssh private key

```bash
ansible-playbook --private-key <ssh private key path> azure-squid.yaml
```

If everything works fine you should see a similar message to 
> VM IP address is 1.2.3.4, Your Public IP: 5.6.7.8, is allowed to access the proxy

You can now use the VM public IP address as a proxy with port 3128 (explicit proxy), your public IP should be allowed in squid.conf

For security reasons, you will have to explicitly allow IP addresses in squid.conf, so the proxy can't be used by any unauthorized clients 