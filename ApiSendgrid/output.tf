output "outputapi" {
   value = sendgrid_api_key.api_key
   description = "API clef pour ludo" 
   depends_on = [
     sendgrid_api_key.api_key
   ]
   sensitive = true 
   
   
}


 resource "local_file" "ma_cle_api" {
  content  =  yamlencode(resource.sendgrid_api_key.api_key[*])
  filename = "Sendgrid.txt"
}  


