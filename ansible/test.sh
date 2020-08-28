#!/bin/bash
set -e
cd $(dirname $0)
pip3 install ansible[azure] packaging
grep -e "$HOME/.local/bin" -e '$HOME/.local/bin' <(echo $PATH) || eval $(echo 'export PATH=$PATH:$HOME/.local/bin' | tee -a ~/.bashrc)
echo -e "$(pwd)/id_rsa\n\n" | ssh-keygen
#echo 'inventory = inventory.txt' >> ansible.cfg
#echo 'localhost ansible_host=localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3' >> inventory.txt
RANDOMNUM=$(shuf -n 1 -i 1-100000)
COMMIT=$(echo $GITHUB_SHA | head -c 7)
export VMNAME=Squid-GH-Actions-$COMMIT-$RANDOMNUM
echo  "$VMNAME" > vmname.txt
ansible-playbook --private-key "$(pwd)/id_rsa" -e testing=True -e vm_name=$VMNAME azure-squid.yaml 
