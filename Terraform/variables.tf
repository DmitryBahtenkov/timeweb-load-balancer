variable "tw_token" {
  type = string
  sensitive = true
}

variable "lb-ips" {
    type = set(string)
}