resource "aws_instance" "ec2_pv" {
    ami = data.aws_ami.amazon_linux
    instance_type = var.instance_type
    subnet_id = var.subnet-id
    vpc_security_group_ids = var.security_group
    
    provisioner "remote-exec" {
    inline = [
        "yum update -y",
        "yum install -y httpd",
        "systemctl start httpd",
        "systemctl enable httpd",
        "echo '<h1>Hello World from $(hostname -f)</h1>' > /var/www/html/index.html",
        "sudo systemctl restart httpd"
    ]


  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2_pv.*.private_ip} > all-ips.txt"
  }
}
resource "aws_instance" "ec2_pv" {
    ami = data.aws_ami.amazon_linux
    instance_type = var.instance_type
    subnet_id = var.subnet-id
    vpc_security_group_ids = var.security_group
    
    provisioner "remote-exec" {
    inline = [
        "yum update -y",
        "yum install -y httpd",
        "systemctl start httpd",
        "systemctl enable httpd",
        "echo '<h1>Hello World from $(hostname -f)</h1>' > /var/www/html/index.html",
        "sudo chmod 777 /etc/httpd/conf/httpd.conf",
        "echo '<VirtualHost*:*>' >> /etc/httpd/conf/httpd.conf",
        "echo -e '\t ProxyPreserveHost on' >> /etc/httpd/conf/httpd.conf",
        "echo -e '\t ServerAdmin ec2-user@localhost' >> /etc/httpd/conf/httpd.conf",
        "echo -e '\t ProxyPass / http://enter/ the private dns name of the private load blancer/' >> /etc/httpd/conf/httpd.conf",
        "echo -e '\t ProxyPassReverse / http://enter/ the private dns name of the private loadblancer/' >> /etc/httpd/conf/httpd.conf",
        "echo '</VirtualHost>' >> /etc/httpd/conf/httpd.conf",
        "sudo systemctl restart httpd",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2_pv.*.public_ip} > all-ips.txt"
  }
}
