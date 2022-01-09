# DB Security Group

resource "aws_security_group" "Project9-database-security" {
  name        = "Project9-database-security"
  description = "Allow http inbound traffic within mysql"
  vpc_id      = aws_vpc.VPC-Project9.id

}

resource "aws_security_group_rule" "Project9database_inbound" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  
  security_group_id = aws_security_group.Project9-database-security.id
}
resource "aws_security_group_rule" "Project9database_outbound" {
  
type              = "egress"

    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

    security_group_id = aws_security_group.Project9-database-security.id
  
  }

 

#The MYSQL

resource "aws_db_instance" "project9_rds1" {
  allocated_storage    = 12
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "project9_rds1"
  username             = "obialo"
  password             = "church12"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = "true"
  db_subnet_group_name = aws_db_subnet_group.Project-sgroup.id
  count = "2"
  
  
  
}


# DB SUBNET GROUP

resource "aws_db_subnet_group" "Project-sgroup" {
  name     = "project-sgroup"
  
  subnet_ids = [aws_subnet.PriWebsite-Subnet1.id, aws_subnet.PriWebsite-Subnet2.id]

  tags = {
    Name = "database-subnetgroup"
  }
}


