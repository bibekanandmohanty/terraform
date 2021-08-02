terraform {
  backend "s3" {
    bucket = "bibek-terraform"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    access_key = "AKIARRSZ75DVG3YXNLQ5"
    secret_key = "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"

  }
}
resource "aws_vpc" "my_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
    Location = "India"
  }
}
output "vpc_cidr" {
  value = "${aws_vpc.my_vpc.cidr_block}"
}
output "vpc_id" {
  value = "${aws_vpc.my_vpc.id}"
}
