variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-b"
}

variable "instance_image" {
  type    = string
  default = "centos-cloud/centos-7"
}

variable "machine_type" {
  type    = string
  default = "custom-1-2304"
}

variable "network_id" {
  type    = string
  default = "centos-cloud/centos-7"
}

variable "subnet_id" {
  type    = string
  default = "custom-1-2304"
}

variable "server_script" {
  type    = string
  default = "./scripts/ELK.sh"
}

variable "client_script" {
  type    = string
  default = ".scripts/Tomcat.sh"
}