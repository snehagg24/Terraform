module "server" {
  source = "./modules/instance"
  
  public_key = var.public_key
}

resource "null_resource" "vsi1-scripts" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("modules/instance/data/id_rsa")
    host        = module.server.instance_ip
  }

  provisioner "remote-exec" {
    inline = [
	  "sudo apt-get -y update",
      "sudo apt-get -y install apache2"
    ]
  }
  
  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  //wait for webpage to be hosted  
  provisioner "remote-exec" {
    inline = [
	  "sleep 10"
	]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
	  "rm /var/www/html/index.html",
      "sudo apt-get -y remove apache2"
    ]
  }
}

data "http" "download_file" {
  url = "http://${module.server.instance_ip}"
}