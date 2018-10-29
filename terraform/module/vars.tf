variable "aws_profile" {
  description = "The profile used as the terraform user to manage AWS resources"
  default     = "terraform-personal"
}

variable "app_name" {
  description = "The name of the app that we will be developing"
  default     = "spa-ghetti"
}
