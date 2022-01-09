# The VPC 

resource "aws_vpc" "VPC-Project9" {
  cidr_block            = var.cirdr-VPC-project9[0]
  instance_tenancy      = "default"
  enable_dns_hostnames =  true

  tags = {
    Name               = "VPC-Project9"
  }
}


# Public Subnet_Project9

resource "aws_subnet" "PubWebsite-Subnet-1" {
  vpc_id            = aws_vpc.VPC-Project9.id
  cidr_block        = var.cirdr-VPC-project9[1]
  map_public_ip_on_launch = "true"

  availability_zone = "us-east-1a"

  tags = {
    Name            = "PubWebsite-Subnet-1"
  }
}


# Public Subnet_2

resource "aws_subnet" "PubWebsite-Subnet-2" {
  vpc_id            = aws_vpc.VPC-Project9.id
  cidr_block        = var.cirdr-VPC-project9[2]
  map_public_ip_on_launch = "true"

  availability_zone = "us-east-1b"

  tags = {
    Name            = "PubWebsite-Subnet-2"
  }
}


#  First Private Subnet -Project9

resource "aws_subnet" "PriWebsite-Subnet1" {
  vpc_id     = aws_vpc.VPC-Project9.id
  cidr_block = var.cirdr-VPC-project9[3]
  map_public_ip_on_launch = "false"

  availability_zone = "us-east-1c"

  tags = {
    Name = "PriWebsite-Subnet1"
  }
}

# #  Second Private Subnet -Project9
resource "aws_subnet" "PriWebsite-Subnet2" {
  vpc_id     = aws_vpc.VPC-Project9.id
  cidr_block = var.cirdr-VPC-project9[4]
  map_public_ip_on_launch = "false"
  
  availability_zone = "us-east-1d"

  tags = {
    Name = "PriWebsite-Subnet2"
  }
}




# Public Website-Route Table

resource "aws_route_table" "Public-routetable" {
  vpc_id = aws_vpc.VPC-Project9.id



  tags = {
    Name = "Public-routetable"
  }
}


# Private Route Table
resource "aws_route_table" "Private-Routetable" {
  vpc_id = aws_vpc.VPC-Project9.id



  tags = {
    Name = "Private-Routetable"
  }
}




# Public Route Table Association of Subnet-1

resource "aws_route_table_association" "Public-RT-Association1" {
  subnet_id      = aws_subnet.PubWebsite-Subnet-1.id
  route_table_id = aws_route_table.Public-routetable.id
}


# Public Route Table Association of Subnet-2

resource "aws_route_table_association" "Public-RT-Association2" {
  subnet_id      = aws_subnet.PubWebsite-Subnet-2.id
  route_table_id = aws_route_table.Public-routetable.id
}



# Private subnet_Database Route Association-1

resource "aws_route_table_association" "Subnet-RTassociation1" {
  subnet_id      = aws_subnet.PriWebsite-Subnet1.id
  route_table_id = aws_route_table.Private-Routetable.id
}

# Private subnet_Database Route Association-1


resource "aws_route_table_association" "Subnet-RTassociation2" {
  subnet_id      = aws_subnet.PriWebsite-Subnet2.id
  route_table_id = aws_route_table.Private-Routetable.id
}


# The_Internet Gateway 


resource "aws_internet_gateway" "internet-Project9" {
  vpc_id       = aws_vpc.VPC-Project9.id

  tags = {
    Name       = "internet-Project9"
  }
}


# Connect of Routable and Internet Gate Way

# Conection of Route to Internet GW And Pub-Route


resource "aws_route" "Public-route-igwroute" {
  route_table_id            = aws_route_table.Public-routetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.internet-Project9.id   
              
} 



# Security_groups

resource "aws_security_group" "Secu-Group" {
  name        = "allow_ssh_http"
  description = "Allow ssh http inbound traffic"
  vpc_id      = aws_vpc.VPC-Project9.id



  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  tags = {
    Name = "allow_ssh_http"
  }
}


