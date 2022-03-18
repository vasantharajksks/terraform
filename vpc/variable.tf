variable "vpcCidr" {
  default     = "10.0.0.0/16"
}
variable "sub_cidr" {
  default     = 8
}
variable "pub_subnet_count" {
 default = 2
}
variable "priv_subnet_count" {
 default = 1
}
variable "pub-ins-sg" {
default = {
    "22" = {
        ports = 22
        protocol = "tcp"
    }
}
}
variable "internet_ip" {
  default     = "0.0.0.0/0"
}
variable "priv-ins-sg" {
default = {
    "22" = {
        ports = 22
        protocol = "tcp"
    }
}
}
