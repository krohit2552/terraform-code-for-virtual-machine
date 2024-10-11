variable "resource_group_name" {
  type        = string
  description = "Name of the Resource group"

}

variable "location" {
  type        = string
  description = "Name of the location"
  default     = "central india"

}

variable "application_name" {
  type        = string
  description = "Name of the application"
  default     = "terraUbuntu"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}