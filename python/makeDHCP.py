#!/usr/bin/python

import MySQLdb
import sys

if __name__ == "__main__":


    #Connect to database
    db = MySQLdb.connect(host="nycs001",user="root",passwd="nycs001",db="dydhcp")
    cursor =db.cursor()
    dhcpFile = open('dhcpConf.txt','w')


    cursor.execute("""select id, netmask, name from subnets""")

    for rows in cursor:
#Make dhcp scopes
        currentRow = cursor.fetchone()
        line = ""
        line += "dhcp server nycdc add scope "
        line += str(currentRow[0]) + " "
        line += str(currentRow[1]) + " "
        line += str(currentRow[2]) + " " + str(currentRow[2]) + "\n"
        dhcpFile.write(line)


#Set state for scopes on
        line = ""
        line += "dhcp server nycdc scope "
        line += str(currentRow[0]) + " set state 0 \n"
        dhcpFile.write(line)

#Define ip address pools
    cursor.execute("""select ip, netmask, id, name, range_lower, range_upper from subnets""")
    for rows in cursor:
        currentRow = cursor.fetchone()
        line = ""
        line += "dhcp server nycdc scope "
        line += str(currentRow[2]) + " add iprange "
        line += str(currentRow[4]) + " "
        line += str(currentRow[5]) + "\n"
        dhcpFile.write(line)

#Get dhcp reservations
    cursor.execute("""select hostname, subnet_id, ip, mac from hosts""")

    for rows in cursor:
        currentRow = cursor.fetchone()
        line = ""
        line += "dhcp server "
        line += str(currentRow[0])
        line += " scope "
        line += str(currentRow[1])
        line += " add reservedip "
        line += str(currentRow[2]) + " "
        line += str(currentRow[3]) + " "
        line += str(currentRow[0]) + " \""
        line += str(currentRow[0]) + "\" "
        line += "BOTH \n"
        dhcpFile.write(line)


Set state for scopes on
    cursor.execute("""select ip, netmask, id, name, range_lower, range_upper from subnets""")
    for rows in cursor:
        currentRow = cursor.fetchone()
        line = ""
        line += "dhcp server nycdc scope "
        line += str(currentRow[2]) + " set state 1 \n"
        dhcpFile.write(line)


    cursor.close()
    db.close()
#now just do "netsh exec c:\path\to\dhcpConf.txt
#also make sure to set default gateway and dns servers for all scopes (server wide)
