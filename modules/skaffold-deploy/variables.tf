variable "service_name" {
  type        = string
  description = "name of service for deploying via skaffold"
  default     = ""
}

variable "skaffold_arg" {
  type        = string
  description = "extra argument to pass to skaffold CLI"
  default     = ""
}

variable "data_files" {
  type        = map(string)
  default     = {}
  description = "files created before running skaffold. key will be created as file path relative to git_relative_path, value will be file content"
}

variable "envs" {
  type        = map(string)
  description = "Environment variables to set when running skaffold"
  default     = {}
}

variable "clone_dir" {
  type        = string
  description = "directory to clone git repo into, under .terraform directory"
  default     = "temp_git_repo"
}

variable "script_run" {
  type        = bool
  description = "Run an additional script before running skaffold"
  default     = false
}

variable "script_path" {
  type        = string
  description = "Relative path from git_relative_path to the script"
  default     = "."
}
