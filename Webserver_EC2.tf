

# Web EC2 -1
resource "aws_instance" "webserver1_project9" {

  ami             = var.first_instance_EC2
  instance_type   = "t2.micro"
  key_name        = "Destroy_EC2"
  subnet_id       = aws_subnet.PubWebsite-Subnet-1.id
 
  availability_zone = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.Secu-Group.id]
  associate_public_ip_address = true
 

  tags = {
  
    
    Name = "webserver1_project9"
  } 
}

# Web EC2 -2
resource "aws_instance" "webserver2_project9" {

  ami             = var.second_instance_EC2 
  instance_type   = "t2.micro"
  key_name        = "Destroy_EC2"
  subnet_id       = aws_subnet.PubWebsite-Subnet-2.id
 
  availability_zone = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.Secu-Group.id]
  associate_public_ip_address = true
 

  tags = {
  
    
    Name = "webserver2_project9"
  } 
}