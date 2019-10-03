alias docker-delete-containers='docker rm $(docker ps -a -q)'
alias docker-delete-images='docker rmi $(docker images -q)'
alias docker-delete-images-dangling='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias wttr="curl wttr.in/ho-chi-minh-city"
