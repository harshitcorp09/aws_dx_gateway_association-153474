provider "aws" {
  region = "ap-south-1"
}

resource "aws_dx_gateway" "lnd_eng_1" {
  name            = "LDN_IXN_ENG_1"
  amazon_side_asn = "64512"
}

resource "aws_ec2_transit_gateway" "main_router" {
  description = "Main Transit Gateway"
}

resource "aws_dx_gateway_association" "lnd_eng_1" {
  dx_gateway_id         = aws_dx_gateway.lnd_eng_1.id
  associated_gateway_id = aws_ec2_transit_gateway.main_router.id

  allowed_prefixes = local.dx_gateway_allowed_prefixes
}

resource "aws_ec2_transit_gateway_route_table" "main_router" {
  transit_gateway_id = aws_ec2_transit_gateway.main_router.id
}

resource "aws_ec2_transit_gateway_route_table_association" "dx_gateway_lnd_eng_1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway.main_router.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main_router.id
}

locals {
  dx_gateway_allowed_prefixes = ["10.0.0.0/16"]
}
