resource "aws_db_subnet_group" "db_subnet" {
  name       = "hackaton_db_subnet"
  subnet_ids = aws_subnet.public_subnets[*].id

  tags = {
    Name = "Hackaton"
  }
}

# Create a security group in the VPC to which the database will belong
resource "aws_security_group" "hackaton_rds" {
  name   = "hackaton_rds"
  vpc_id = aws_vpc.hackaton_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a random password
resource "random_string" "uddin-db-password" {
  length  = 32
  upper   = true
  special = false
}

# Configure database instance
resource "aws_db_instance" "hackaton_db" {
  identifier             = "hackaton-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "15.3"
  username               = "postgres"
  password               = random_string.uddin-db-password.result
  db_name                = "hackaton"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.hackaton_rds.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}
