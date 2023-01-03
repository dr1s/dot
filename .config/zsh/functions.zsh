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
  pyenv shell trobz
  anhoi config ssh -u "${user}" >> "${ssh_config}"
  pyenv shell "${python_version}"
}

awx_run() {
  python_version="$(pyenv version | cut -d\  -f 1)"
  pyenv shell awxkit
  job_id=$(awx job_templates list --all | jq -r '.results[] | [.id, .name] | @tsv' | fzf --no-sort | awk '{print $1}')
  awx job_templates launch --monitor $@ "$job_id"
  #tower-cli job launch -J $(tower-cli job_template list --page-size 100 | head -n -1 | tail -n +4 | fzf --no-sort --tac | awk '{print $1}') --monitor $@
  pyenv shell "${python_version}"
}

hostvars() {
  python_version="$(pyenv version | cut -d\  -f 1)"
  pyenv shell trobz
  query="._meta.hostvars[\"$1\"]"
  anhoi sync --no-nice --no-cache | jq "$query"
  pyenv shell "${python_version}"
}

ssht () {
  /usr/bin/ssh -t $@ "tmux -CC new-session -A";
}

awx_adhoc(){
  limit=$1
  shift
  args="$@"
  echo $args
  tower-cli ad_hoc launch --become-enabled true --monitor --module-name shell --module-args $args -i tms_inventory --credential ssh-deploy --limit "${limit}"
}

door-open(){
  curl --user daniel:$(pass trobz/httpauth.trobz.com | head -1) https://doors-api.trobz.com/opendoor/192.168.1.150
}
