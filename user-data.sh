#!/bin/bash -ex

{
# change sudoer
sed -i 's/^Defaults    requiretty/Defaults:ec2-user    !requiretty/' "/etc/sudoers"

# use JST
ln -sf "/usr/share/zoneinfo/Asia/Tokyo" "/etc/localtime"
sed -i -e 's@"UTC"@"Asia/Tokyo"@' -e 's/true/false/' "/etc/sysconfig/clock"

# change hostname
sed -i "s/localhost\.localdomain/$HOST_NAME/" "/etc/sysconfig/network"
hostname "$HOST_NAME"

# for ohai
mkdir -p "/etc/chef/ohai/hints"
touch "/etc/chef/ohai/hints/ec2.json"

# change ssh port
sed -i "s/#Port 22/Port $PORT/" "/etc/ssh/sshd_config"
service sshd restart

# update
yum -y update

# change mta to postfix
service sendmail stop
chkconfig sendmail off
yum install -y postfix
/usr/sbin/alternatives --set mta "/usr/sbin/sendmail.postfix"
yum remove -y sendmail
service postfix start
chkconfig postfix on

} | tee -a /root/install.log

