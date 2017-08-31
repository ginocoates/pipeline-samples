variable environment-name {
  type = "string"
}

variable cluster-dns {
  type = "string"
}

variable vpc-id {
  type = "string"
}

variable alb-subnet-ids {
  type="string"
}

variable cluster-subnet-ids {
  type="string"
}

variable "region" {
  type = "string"
}

variable "service-role-arn" {
  type = "string"
}

variable "task-role-arn" {
  type="string"
}

variable "autoscale-role-arn" {
  type="string"
}

variable "alb-certificate-arn" {
  type="string"
}

variable "cluster-scale-min" {
  type="string"
}

variable "cluster-scale-max" {
  type="string"
}

variable "cluster-instance-type" {
  type="string"
}

variable "cluster-key-pair" {
  type="string"
}

variable "service1-min-scale" {
  type="string"
}

variable "service1-max-scale" {
  type="string"
}

variable "service1-build" {
  type="string"
}
