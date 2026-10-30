variable "git_repo_url" {
  type        = string
  description = "Public URL of the submitted GitHub fork"
}

variable "git_branch" {
  type        = string
  description = "Branch containing the application Dockerfile"
  default     = "solution/anjan-prajapati"
}