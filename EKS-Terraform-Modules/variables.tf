variable "region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "ap-south-1"
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "availability_zones" {
    description = "list of availability zones in the region"
    type        = list(string)
    default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"] 
}

variable "public_subnet_cidrs"{
    description = "list of public subnet CIDR blocks"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
    description = "list of private subnet CIDR blocks"
    type        = list(string)
    default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default     = "my-eks-cluster"
}

variable "cluster_version" {
    description = "EKS cluster version"
    type        = string
    default     = "1.30"
}

variable "node_groups" {
    description = "Node groups for the EKS cluster"
    type        = map(object({
        instance_types = list(string)
        capacity_type  = string
        scaling_config = object({
            desired_size = number
            max_size     = number
            min_size     = number
        })
    }))
    default     = {
        general = {
            instance_types = ["t3.medium"]
            capacity_type  = "ON_DEMAND"
            scaling_config = {
                desired_size = 2
                max_size     = 4
                min_size     = 1
            }
        }
    }
}

