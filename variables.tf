# naming parts
variable "org_infix" {
  type = string
}

variable "project_infix" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}

# images
variable "image_resource_group_name" {
  type = string
}

variable "image_gallery_name" {
  type = string
}

variable "wordpress_image_name" {
  type    = string
  default = "img-wordpress"
}

variable "wordpress_image_version" {
  type    = string
  default = "1.0.0"
}

# ssh username and password
variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

# mysql username and password
variable "mysql_username" {
  type = string
}

variable "mysql_password" {
  type      = string
  sensitive = true
}