provider "aws" {
  region = "ap-south-1"
}

resource "aws_dx_gateway" "example" {
  name   = "example"
  amazon_side_asn = 64512
}

resource "aws_ec2_transit_gateway" "example" {
  description = "example"
  amazon_side_asn = 64513
}

resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

resource "aws_dx_gateway_association" "example" {
  dx_gateway_id        = aws_dx_gateway.example.id
  allowed_prefixes     = ["10.0.0.0/16"]
  associated_gateway_id   = aws_ec2_transit_gateway.example.id
}

resource "aws_ec2_transit_gateway_route_table_association" "example" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
  transit_gateway_attachment_id  = "tgw-attach-0ba3fac2cb8f693b4"
}
