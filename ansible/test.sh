#!/bin/bash
cd $(dirname $0)
pip3 install --user ansible[azure]
update-alternatives --install python /usr/bin/python3
grep -e "$HOME/.local/bin" -e '$HOME/.local/bin' <(echo $PATH) || eval $(echo 'export PATH=$PATH:$HOME/.local/bin' | tee -a ~/.bashrc)
echo -e "$HOME/.ssh/squidkey\n\n" | ssh-keygen
echo 'inventory = inventory.txt' >> ansible.cfg
echo 'localhost ansible_host=localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3' >> inventory.txt
ansible-playbook --private-key "$HOME/.ssh/squidkey" azure-squid.yaml -e testing=True
