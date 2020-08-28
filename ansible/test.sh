#!/bin/bash
set -e
cd $(dirname $0)
pip3 install ansible[azure] packaging
update-alternatives --install /usr/bin/python python /usr/bin/python3 0
grep -e "$HOME/.local/bin" -e '$HOME/.local/bin' <(echo $PATH) || eval $(echo 'export PATH=$PATH:$HOME/.local/bin' | tee -a ~/.bashrc)
echo -e "$(pwd)/id_rsa\n\n" | ssh-keygen
#echo 'inventory = inventory.txt' >> ansible.cfg
#echo 'localhost ansible_host=localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3' >> inventory.txt
export VMNAME=Squid-GH-Actions-$GITHUB_SHA
echo  "$VMNAME" > vmname.txt
ansible-playbook --private-key "$(pwd)/id_rsa" -e testing=True -e vm_name=$VMNAME azure-squid.yaml 
