#!/bin/bash

###setup puppet when re-imaging a system

centVersion=$(cut -d' ' -f3 < /etc/redhat-release)
hostnameCur=$(hostname)
logFileLoc="/root/puppetSingle.log"
if [ -f $logFileLoc ]
then
    rm $logFileLoc
fi
touch $logFileLoc


# Install puppet
echo "making sure puppet is installed"
cp /mnt/Path/On/nfs/centos_$centVersion/puppetlabs.repo /etc/yum.repos.d/puppetlabs.repo
sed -e 's/enabled=0/enabled=1/g' -i /etc/yum.repos.d/epel.repo
yum -y --nogpgcheck install puppet &>> $logFileLoc
echo "\n" &>> $logFileLoc
if [ $? ]
then
    echo "install failed"
else
    echo "puppet installed"
fi
sed -e 's/enabled=1/enabled=0/g' -i /etc/yum.repos.d/epel.repo

# Config puppet
/bin/mv /etc/puppet/puppet.conf /etc/puppet/puppet.conf.bak
/bin/cp /Path/On/nfs/centos_$centVersion/puppet.conf /etc/puppet/puppet.conf
chkconfig puppet on
service puppet restart

#find /var/lib/puppet/ssl -name $hostnameCur.my.company.com.prem -delete
if [ -f /var/lib/puppet/ssl/certificate_requests/$hostnameCur.my.company.com.prem ]
then
    # If an old cert exists get rid of it
    /bin/mv /var/lib/puppet/ssl/certificate_requests/$hostnameCur.my.company.com.prem /var/lib/puppet/ssl/certificate_requests/$hostnameCur.my.company.com.prem.bak
fi
if [ -f /var/lib/puppet/ssl/certs/$hostnameCur.my.company.com.pem ]
then
    #Delete signed cert if exists
    /bin/rm /var/lib/puppet/ssl/certs/$hostnameCur.my.company.com.pem
fi


# Create cert and ask to be signed
puppet agent --digest SHA256 -t --server puppet-master &>> $logFileLoc
if [ $? ] 
then
    echo "Cert Created: Go on puppet-master and sign the cert now"
else
    echo "Puppet cert creation failed"
fi
