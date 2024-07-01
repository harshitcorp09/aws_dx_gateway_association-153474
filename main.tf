provider "aws" {
  region = "ap-south-1"
}

# Create Direct Connect Gateway
resource "aws_dx_gateway" "example" {
  name            = "example-dx-gateway"
  amazon_side_asn = 64513
}

# Create Transit Gateway
resource "aws_ec2_transit_gateway" "example" {
  description = "example-transit-gateway"
  tags = {
    Name = "example-transit-gateway"
  }
}
