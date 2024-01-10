#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <EC2_Instance_IP>"
    exit 1
fi
EC2_IP=$1
ssh -i /home/ec2-user/PRVN.pem ec2-user@$EC2_IP << 'EOF'
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
sudo bash -c 'cat <<EOF2 > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>NatWest Group</title>
</head>
<body>
    <h1>**Welcome to NatWest Group**</h1>
    <p>This is a simple HTML page hosted on an EC2 instance running Welcome to NatWest Group .</p>
</body>
</html>
EOF2'
EOF



# Ensure the script has execute permissions: chmod +x deploy_webserver.sh
# ./ deploy_webserver.sh <EC2_Instance_IP>
# 54.224.66.194
