data "http" "myip" {
  url = "http://ifconfig.me/ip"
}

data "http" "downloadcert" {
  url = "https://cacerts.digicert.com/BaltimoreCyberTrustRoot.crt.pem"
}