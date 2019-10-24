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

awx_run() {
  python_version="$(pyenv version | cut -d\  -f 1)"
  pyenv shell towercli
  tower-cli job launch -J $(tower-cli job_template list --page-size 100 | fzf --no-sort --tac | awk '{print $1}') $@
  pyenv shell "${python_version}"
}

