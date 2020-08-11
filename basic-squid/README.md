## Simple Squid deployment scripts on MS Azure VM

### Requirements
- bash
- sed
- grep
- curl
- [az](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

### Usage
1. Tweak configuration in config.sh to meet preferences

2. Optionally, tweak cloud-init.txt.example (i.e to tweak squid.conf)

3. deploy ```bash ./azure-deploy.sh```
