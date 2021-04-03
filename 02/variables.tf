/* Credentials and project configuration */
variable "project_id" {
  type    = string
  default = "splendid-sunset-291720"
}

variable "credentials_filename" {
  type    = string
  default = "splendid-sunset-291720-893c7030a5b8.json"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-b"
}

/* Network configuration */

variable "network_name" {
  type    = string
  default = "ldap-network"
}

variable "subnet_name" {
  type    = string
  default = "ldap-subnetwork"
}

/* Instances configuration */

// Ubuntu 20.04
variable "instance_image" {
  type    = string
  default = "centos-cloud/centos-7"
}

variable "machine_type" {
  type    = string
  default = "custom-1-2304"
}

variable "server_script" {
  type    = string
  default = "./modules/instances/scripts/ELK.sh"
}

variable "client_script" {
  type    = string
  default = "./modules/instances/scripts/Tomcat.sh"
}