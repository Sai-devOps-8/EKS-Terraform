resource "aws_vpc" "vpc-main" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = { 
        Name                                         = "${var.cluster_name}-vpc"
        "kubernetes.io/clusters/${var.cluster_name}" = "shared"   # This tag is required for EKS to recognize the VPC ##tells AWS that: This resource (like a VPC or subnet) is shared across multiple Kubernetes clusters, or is available for use by Kubernetes.
}
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.vpc-main.id 
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = false
    tags = { 
        Name                                        = "${var.cluster_name}-private-subnet-${count.index}"
        "kubernete.io/clusters/${var.cluster_name}" = "shared" 
        "kubernetes.io/role/internal-elb"           = "1" ## This tag is required for EKS to recognize the public subnets for Load balancers.

    }
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.vpc-main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name                                         = "${var.cluster_name}-public-subnet-${count.index}"
        "kubernetes.io/clusters/${var.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                     = "1" # This tag is required for EKS to recognize the public subnets for Load balancers.
    }
    }

resource "aws_internet_gateway" "igw-main" {
    vpc_id = aws_vpc.vpc-main.id
    tags = {
        Name                                         = "${var.cluster_name}-igw"
        "kubernetes.io/clusters/${var.cluster_name}" = "shared"

    }
}

resource "aws_eip" "nat-eip" {
    count = length(var.public_subnet_cidrs)
    associate_with_private_ip = null
    tags = {
        Name = "${var.cluster_name}-nat-eip-${count.index + 1}"

    }
}

resource "aws_nat_gateway" "nat-gateway" {
    count = length(var.public_subnet_cidrs)
    allocation_id = aws_eip.nat-eip[count.index].id
    subnet_id = aws_subnet.public[count.index].id
    tags = {
        Name = "${var.cluster_name}-nat-gateway-${count.index + 1}"
     } 
     }

    
resource "aws_route_table" "public-rt" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.vpc-main.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-main.id
    }
    tags = {
        Nmae = "${var.cluster_name}-public-route-table"
    }
}

resource "aws_route_table" "private-rt" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.vpc-main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gateway[count.index].id

    }
    tags = {
        Name = "${var.cluster_name}-private-route-table"
    }

}
 

resource "aws_route_table_association" "public-rt-assoc" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public-rt[count.index].id
}

resource "aws_route_table_association" "private-rt-assoc"{
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private-rt[count.index].id
}


  
