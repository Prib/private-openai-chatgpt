data "http" "ip" {
  url = "https://ipinfo.io/ip"
}

locals {
  build_agent_ip = data.http.ip.body
}