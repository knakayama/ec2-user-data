#!/bin/bash -ex

{
sed -i 's/^Defaults    requiretty/Defaults:ec2-user    !requiretty/' "/etc/sudoers"
ln -sf "/usr/share/zoneinfo/Asia/Tokyo" "/etc/localtime"
sed -i -e 's@"UTC"@"Asia/Tokyo"@' -e 's/true/false/' "/etc/sysconfig/clock"
sed -i "s/localhost\.localdomain/$HOST_NAME/" "/etc/sysconfig/network"
hostname "$HOST_NAME"
mkdir -p "/etc/chef/ohai/hints"
touch "/etc/chef/ohai/hints/ec2.json"
sed -i 's/#Port 22/Port 65467/' "/etc/ssh/sshd_config"
service sshd restart
yum -y update
service sendmail stop
chkconfig sendmail off
yum install -y postfix
/usr/sbin/alternatives --set mta "/usr/sbin/sendmail.postfix"
yum remove -y sendmail
service postfix start
chkconfig postfix on
} | tee -a /root/install.log

