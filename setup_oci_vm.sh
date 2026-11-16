#!/bin/bash
# ==============================================================================
# CampusConnect - Automated Setup Script for Oracle Cloud Infrastructure (OCI)
# Works on: Ubuntu 20.04/22.04/24.04 and Oracle Linux 8/9 (Compute VM)
# ==============================================================================

set -e

echo "=== [1/5] Updating System Packages ==="
if [ -f /etc/debian_version ]; then
    sudo apt-get update -y
    sudo apt-get install -y openjdk-17-jdk curl wget unzip iptables-persistent
elif [ -f /etc/redhat-release ]; then
    sudo dnf update -y
    sudo dnf install -y java-17-openjdk-devel curl wget unzip firewalld
fi

echo "=== [2/5] Installing Apache Tomcat 10.1 ==="
TOMCAT_VERSION="10.1.34"
sudo mkdir -p /opt/tomcat
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O tomcat.tar.gz || \
wget https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O tomcat.tar.gz

sudo tar -zxvf tomcat.tar.gz -C /opt/tomcat --strip-components=1
sudo chmod +x /opt/tomcat/bin/*.sh

echo "=== [3/5] Configuring Port 8080 Firewall on VM ==="
# OCI Linux instances have internal iptables/firewalld blocking non-22 ports by default
if [ -f /etc/debian_version ]; then
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
    sudo netfilter-persistent save || true
elif [ -f /etc/redhat-release ]; then
    sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp || true
    sudo firewall-cmd --reload || true
fi

echo "=== [4/5] Deploying CampusConnect.war ==="
if [ -f /tmp/CampusConnect.war ]; then
    sudo cp /tmp/CampusConnect.war /opt/tomcat/webapps/CampusConnect.war
    echo "CampusConnect.war deployed to /opt/tomcat/webapps/"
else
    echo "Notice: Place your CampusConnect.war in /tmp/ and run:"
    echo "  sudo cp /tmp/CampusConnect.war /opt/tomcat/webapps/"
fi

echo "=== [5/5] Starting Tomcat 10 Server ==="
sudo /opt/tomcat/bin/shutdown.sh || true
sleep 2
sudo /opt/tomcat/bin/startup.sh

echo "=============================================================================="
echo "Deployment Ready!"
echo "Make sure Port 8080 is opened in OCI Console -> VCN -> Ingress Rules."
echo "Application URL: http://<YOUR_OCI_PUBLIC_IP>:8080/CampusConnect/"
echo "=============================================================================="
