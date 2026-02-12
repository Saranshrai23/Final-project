variable "name" { type = string }
variable "region" { type = string }

variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }

variable "endpoint_public_access" { type = bool }
variable "endpoint_private_access" { type = bool }

variable "desired_size" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }

