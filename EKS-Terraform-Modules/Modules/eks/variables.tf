variable "cluster_name" {
    description = "The name of the Eks cluster"
    type        = string 
}

variable "cluster_version" {
    description = "The version of the EKS cluster"
    type = string
}

variable "vpc_id" {   ####EKS needs to know the VPC ID to create the Cluster in VPC
    description = "The VPC ID to use for the EKs cluster"
    type        = string 
}

variable "subnet_ids" {
    description = "The subnets to use for the EKS cluster"
    type        = list(string)
    }

variable "node_groups" {
    description = "The node groups to create for the EKS cluster"
    type = map(object({
        instance_types = list(string)
        capacity_type  = string
        scaling_config = object({
            desired_size = number
            max_size     = number
            min_size     = number
        })
    }))
}

