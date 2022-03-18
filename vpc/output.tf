output "vpc-id" {
  value = aws_vpc.ninja-vpc.id
}
output "igw-output" {
  value = aws_internet_gateway.igw.id
}
output "public-route-table" {
  value = aws_route_table.pub-route.id
}
output "private-route-table" {
  value = aws_route_table.priv-route.id
}
