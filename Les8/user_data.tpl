#!/bin/bash
echo "-----------GOGOGOGO-------------------"
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2> Build by Terraform <font color="red"> v0.12.12</font></h2><br>
Owner: ${f_name} ${l_name} <br>

%{for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>

EOF
service httpd start
chkconfig httpd on
echo "-----------FINISH-----------"
