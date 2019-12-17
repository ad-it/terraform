#!/bin/bash
echo "-----------GOGOGOGO-------------------"
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body bgcolor=black><center><h2><p><font color=red>Hello guys</h2></center></body></html>" > /var/www/html/index.html
echo "<h2> WebServer with IP: $myip </h2><br>Build by Terraform!" > /var/www/html/index.html
service httpd start
chkconfig httpd on
echo "-----------FINISH-----------"
