variable "rgname" {

type = string
description = "used for naming the resource group"
  
}

variable "rglocation" {
  
  type = string
  description = "used for selecting the location"
}

variable "nsg" {

    
  type = string
  description = "name of the nsg"
}

variable "Vnet" {

    type = string
    description = "name of the vnet"
  
}

variable "subnet" {

    type = string
    description = "name of the subnet"
  
}

variable "nic" {

    type = string
    description = "name of the nic"
  
}

variable "terra-ip" {

    type = string
    description = "name of the public ip"
  
}

variable "VM" {

    type = string
    description = "name of the vm"
  
}