provider "aws" {
  region = "ap-south-1"
}

# Create Direct Connect Gateway
resource "aws_dx_gateway" "example" {
  name            = "example-dx-gateway"
  amazon_side_asn = 64512
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
  allowed_prefixes   = ["10.0.0.0/16"]  # Adjust according to your on-premises network prefixes
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

# Associate Transit Gateway with Route Table
resource "aws_ec2_transit_gateway_route_table_association" "example" {
  transit_gateway_attachment_id = aws_dx_gateway_association.example.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}

# Optional Outputs
output "dx_gateway_id" {
  value = aws_dx_gateway.example.id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.example.id
}

output "transit_gateway_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.example.id
}

output "dx_gateway_association_id" {
  value = aws_dx_gateway_association.example.id
}
