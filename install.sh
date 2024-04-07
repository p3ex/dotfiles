#!/bin/bash
# Keep this script simple and easily as you can
# set -e
main() {
#Check Git version
git_version=`git --version | awk '{print $3}'`
if [[ $(git --version > /dev/null 2>&1; echo $?) -ne 0 ]]; then
    echo "Git is not installed!"
    exit 1
fi
#check Python version
python_major_version=`python3 -V | awk '{print $2}' | cut -d. -f2`
if [[ "$python_major_version" -lt 8 ]]; then
    echo "Python version required > 3.8"
    exit 1
fi

## Install ansible and run playbook
python3 -m venv dotenv
./dotenv/bin/python3 -m pip install -r requirements.txt
echo -e "Ansible was successfully installed \n"
echo -e "Enter password to decrypt secrets..."
read -s vault_pass
echo $vault_pass > .vault

encrypt_all() {
for i in $(find ./secrets -type f); do 
ansible-vault encrypt $i  --vault-password-file evns/.vault \
&& echo $i encrypted ; 
done
}
encrypt_all

decrypt_all(){
for i in $(find ./secrets -type f)
do 
    ansible-vault decrypt $i  --vault-password-file evns/.vault \
    && echo $i decrypted ; 
done
}
# decrypt_all
}
main "$1"