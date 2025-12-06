// Region - us-east-1 
// vpc - default
// SG - default - http, https, ssh 
// myasg
// mylb 

1. Create Template | Version 1 

advanced >>

#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
if ! getent group apache >/dev/null; then
    groupadd apache
fi
usermod -aG apache ec2-user
chmod 755 /var/www/html
echo "<h1>Hello from $(hostname -f) webserver</h1>" > /var/www/html/index.html

2. Create ASG 

min 1
max 5
desired 3

3. Create Target Group 

health check: /index.html

4. ASG >> modify >> Create Loadbalancer 

5. deregister instances from Target Group 

6. delete Load Balancer 

7. delete Target Group

8. delete ASG 
