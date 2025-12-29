# ==============================
# Create Key Pair
# ==============================
resource "aws_key_pair" "this" {
  key_name   = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}-key"
  public_key = file(var.public_key)  # <- read the actual key contents

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}-key"
    }
  )
}

# ==============================
# Create EC2 Instance
# ==============================
resource "aws_instance" "this" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2023 (us-east-1)
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = file(var.script_path)  # Your setup script

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}"
    }
  )
}
