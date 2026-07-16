#!/bin/bash

dnf update -y
dnf install nginx -y

systemctl enable nginx
systemctl start nginx

echo "<h1>Terraform Multi-Tier Infrastructure</h1>" > /usr/share/nginx/html/index.html
echo "<h2>Hostname: $(hostname)</h2>" >> /usr/share/nginx/html/index.html
echo "<h3>Provisioned by Terraform</h3>" >> /usr/share/nginx/html/index.html