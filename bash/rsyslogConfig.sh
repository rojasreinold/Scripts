#!/bin/bash

#replaces *.* @IPADDRESS with graylog ip address, port, and network protocol
sed -r 's/^#?\*\.\*\s@{1,2}([0-9]{1,3}\.){3}[0-9]{1,3}(:[0-9]+)?/\*\.\* @@192\.168\.1\.1:514/g' -i /etc/rsyslog.conf

#replaces *.* @remote-host with graylog ip address, port, and network protocol
sed -r 's/^#?\*\.\*\s@{1,2}remote-host(:[0-9]+)?/\*\.\* @@192\.168\.1\.1:514/g' -i /etc/rsyslog.conf

echo "Changed rsyslog server IP"

sleep 3
service rsyslog restart

