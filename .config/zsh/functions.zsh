anhoi-ssh-config(){
  ssh_config=${1:-"${HOME}/.ssh/config"}
  pk=${2:-"${HOME}/.ssh/trobz_rsa"}
  user=${3:-"trobz"}
  python_version="$(pyenv version | cut -d\  -f 1)"
  cat <<EOF > "${ssh_config}"
Host *.lan
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
Host *.trobz.com
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ${pk}
EOF
  pyenv shell anhoi
  anhoi config ssh -u "${user}" >> "${ssh_config}"
  pyenv shell "${python_version}"
}
export PATH="/Users/drs/bin/Sencha/Cmd:$PATH"

update_authorized_keys(){
  pyenv shell 3.7.2
  tower-cli inventory_source update 10 --monitor
  tower-cli job launch -J 11 --limit "${1}"  --monitor
}

update_htpasswd(){
  pyenv shell 3.7.2
  tower-cli inventory_source update 10 --monitor
  tower-cli job launch -J 38 --limit "${1}" -e "INSTANCE=openerp-${2}" --monitor
}

update_public_keys(){
  pyenv shell 3.7.2
  tower-cli job launch -J 35 --monitor
}
