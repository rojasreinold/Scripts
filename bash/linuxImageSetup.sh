#!/bin/bash
###Setup a workstation after re-imaging

echo "what is the hostnumber? ex: 001 \n"
read newHostName
echo "What is the new mac Address?\n"
read newMacAddress
#reconfigure networking settings
if -f /etc/network
    sed -ir 's/host-[0-9][0-9][0-9]-name/host-$newHostName-name/g' /etc/network
fi

for item in $(ls /etc/sysconfig/network-scripts/ifcfg-e*)
do
    sed -ir 's/host-[0-9][0-9][0-9]-name/$newHostName/g' $item
    sed -r 's/HWADDR=.*/HWADDR=$newMacAddress/g' $item
done

hostname $newHostName

service network restart 
echo "configureed networking"


#bind to domain
echo "binding to domain"
sed -r 's/ldap_sasl_authid = HOST-[0-9][0-9][0-9]-NAME\$@HOST.COMPANY.LOCAL/ldap_sasl_authid = HOST-$newHostName-NAME\$@HOST.COMPANY.COM/g' -i /etc/sssd/sssd.conf 
net ads join -U username

service sssd restart 
./puppetSingle.sh

echo "Done"
