sudo sed -i 's#http://archive\.ubuntu\.com/ubuntu#http://azure\.archive\.ubuntu\.com/ubuntu#g' /etc/apt/sources.list
sudo sed -i 's#http://[a-z][a-z]\.archive\.ubuntu\.com/ubuntu#http://azure\.archive\.ubuntu\.com/ubuntu#g' /etc/apt/sources.list
sudo sed -i 's#http://security\.ubuntu\.com/ubuntu#http://azure\.archive\.ubuntu\.com/ubuntu#g' /etc/apt/sources.list
sudo sed -i 's#http://[a-z][a-z]\.security\.ubuntu\.com/ubuntu#http://azure\.archive\.ubuntu\.com/ubuntu#g' /etc/apt/sources.list
sudo apt-get update

sudo apt-get update
sudo apt-get install linux-azure linux-image-azure linux-headers-azure linux-tools-common linux-cloud-tools-common linux-tools-azure linux-cloud-tools-azure
sudo apt-get full-upgrade
sudo touch /var/log/ansible.log
sudo chmod go+rw /var/log
sudo chmod go+rw /var/log/ansible.log

sudo apt-get install -y walinuxagent cloud-init cloud-utils-growpart gdisk hyperv-daemons

# sudo systemctl enable waagent.service
# sudo systemctl enable cloud-init.service
#
# sudo sed -i 's/Provisioning.Agent=auto/Provisioning.Agent=cloud-auto/g' /etc/waagent.conf
# sudo sed -i 's/ResourceDisk.Format=y/ResourceDisk.Format=n/g' /etc/waagent.conf
# sudo sed -i 's/ResourceDisk.EnableSwap=y/ResourceDisk.EnableSwap=n/g' /etc/waagent.conf

# Prevent cloudconfig from preserving the original hostname and reset the hostname
# URL: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/hybrid/server/best-practices/vmware-ubuntu-template?toc=%2Fazure%2Fcloud-adoption-framework%2Fscenarios%2Fhybrid%2Ftoc.json
sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
sudo truncate -s0 /etc/hostname
sudo hostnamectl set-hostname localhost

# Remove the current network configuration
sudo rm /etc/netplan/50-cloud-init.yaml

# Clean shell history
cat /dev/null > ~/.bash_history && history -c

# Clean machine-id
sudo rm -f /etc/machine-id && sudo touch /etc/machine-id

/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync && sync && sync
