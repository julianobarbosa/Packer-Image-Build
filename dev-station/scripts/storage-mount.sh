sudo mkdir /mnt/dev
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/stgdevopsulianobarbosa.cred" ]; then
    sudo bash -c 'echo "username=stgdevopsulianobarbosa" >> /etc/smbcredentials/stgdevopsulianobarbosa.cred'
    sudo bash -c 'echo "password=lipLBJfeKodN6TP3gY3jAUJJ3ZNd61N5XxFf3f+7q0PC//WrWGILS5cmMmK9DfufehH5IfqFFC6K+ASt+IzGhw==" >> /etc/smbcredentials/stgdevopsulianobarbosa.cred'
fi
sudo chmod 600 /etc/smbcredentials/stgdevopsulianobarbosa.cred

sudo bash -c 'echo "//stgdevopsulianobarbosa.file.core.windows.net/dev /mnt/dev cifs nofail,credentials=/etc/smbcredentials/stgdevopsulianobarbosa.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //stgdevopsulianobarbosa.file.core.windows.net/dev /mnt/dev -o credentials=/etc/smbcredentials/stgdevopsulianobarbosa.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
