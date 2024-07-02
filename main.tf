provider "aws" {
  region = "ap-south-1"
}

# Create Direct Connect Gateway
resource "aws_dx_gateway" "example" {
  name            = "example-dx-gateway"
  amazon_side_asn = 64514
}

# Create Transit Gateway
resource "aws_ec2_transit_gateway" "example" {
  description = "example-transit-gateway"
  tags = {
    Name = "example-transit-gateway"
  }
}

# Create Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  tags = {
    Name = "example-transit-gateway-route-table"
  }
}

# Associate Direct Connect Gateway with Transit Gateway
resource "aws_dx_gateway_association" "example" {
  dx_gateway_id      = aws_dx_gateway.example.id
  allowed_prefixes   = ["10.0.0.0/16" , "10.1.0.0/16"]  # Adjust according to your on-premises network prefixes
  associated_gateway_id = aws_ec2_transit_gateway.example.id
}
# Create a Transit Gateway VPC Attachment as a placeholder
resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = "vpc-065094bd3867b53af"
  subnet_ids         = ["subnet-056001c77a8f9cbcd"]

  tags = {
    Name = "example-transit-gateway-vpc-attachment"
  }
transit_gateway_default_route_table_association = false
}
# Data source to fetch the existing VPC attachment
data "aws_ec2_transit_gateway_vpc_attachment" "example" {
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.example.id]
  }

  filter {
    name   = "vpc-id"
    values = ["vpc-065094bd3867b53af"]
  }
}

# Associate Transit Gateway with Route Table
resource "aws_ec2_transit_gateway_route_table_association" "example" {
  transit_gateway_attachment_id = data.aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}
