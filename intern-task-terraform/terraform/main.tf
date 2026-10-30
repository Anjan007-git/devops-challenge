user_data = templatefile("${path.module}/user_data.sh.tftpl", {
  git_repo_url = var.git_repo_url
  git_branch   = var.git_branch
  app_port     = var.app_port
  ssh_cidr     = var.ssh_cidr
})

user_data_replace_on_change = false