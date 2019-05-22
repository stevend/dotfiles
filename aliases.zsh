alias be="bundle exec"

alias gco="git checkout"
alias gsp="git smart-pull"

alias kc="knuckle_cluster"

alias av-finprod-console="aws-vault login -s envato-finance-production-power-user"
alias av-findev-console="aws-vault login -s envato-finance-development-power-user"

alias av-findev-pu="aws-vault exec envato-finance-development-power-user -- bundle exec "
alias av-findev-cf="aws-vault exec envato-finance-development-cloudformation-user -- bundle exec "
alias av-finprod-pu="aws-vault exec envato-finance-production-power-user -- bundle exec "
alias av-finprod-cf="aws-vault exec envato-finance-production-cloudformation-user -- bundle exec "

alias branch-cleanup="git branch --merged | grep -v '\*' | grep -v master | grep -v dev | xargs -n 1 git branch -d"
