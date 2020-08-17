## Squid deployment and configuration ansible playbook on MS Azure VM

### Requirements
- Linux environment or similar (i.e WSL2)
- curl
- Python 3.6 or 3.7 (virtualenv is fine)
- ansible and ansible azure modules
- a certificate authority with private key include
- [az](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

### Preparing dependencies
1. Install Python 3.6 or 3.7 this can be done using the package manager of your distribution or by installing python manually from python.org, you can make use of open source tools like [pyenv](https://github.com/pyenv/pyenv)

2. Install curl using your distibution package manager

3.

```bash
curl -L https://aka.ms/InstallAzureCli | bash # Install az
pip3 install --user ansible[azure]
```

4. Create certificate authority at squid.pem (or copy your CA to squid.pem)

```

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

5. Login to azure with az command 

```bash
az login
```

### Usage
1. Tweak configuration in config_vars.yaml to meet preferences, replace the example ssh public key with your ssh public key

2. Optionally, tweak squid.conf.j2 template file (i.e to tweak target squid.conf)

3. execute the following command:

```bash
ansible-playbook -i <path to your ssh private key> azure-squid.yaml
```

If everything works fine you should see a similar message to 
> VM IP address is 1.2.3.4, Your Public IP: 5.6.7.8, is allowed to access the proxy
