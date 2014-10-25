#!/bin/bash -ex

{
# change sudoer
if cat "/etc/issue" | grep -qF 'Ubuntu'; then
    echo "Defaults:ubuntu    !requiretty" >> "/etc/sudoers.d/90-cloud-init-users"
else
    sed -i 's/^Defaults    requiretty/Defaults:ec2-user    !requiretty/' "/etc/sudoers"
fi

# use JST
ln -sf "/usr/share/zoneinfo/Asia/Tokyo" "/etc/localtime"
if ! cat "/etc/issue" | grep -qF 'Ubuntu'; then
    sed -i -e 's@"UTC"@"Asia/Tokyo"@' -e 's/true/false/' "/etc/sysconfig/clock"
fi

# change hostname
if cat "/etc/issue" | grep -qF 'Ubuntu'; then
    echo "$HOST_NAME" > "/etc/hostname"
else
    sed -i "s/localhost\.localdomain/$HOST_NAME/" "/etc/sysconfig/network"
fi
hostname "$HOST_NAME"

# for ohai
mkdir -p "/etc/chef/ohai/hints"
touch "/etc/chef/ohai/hints/ec2.json"

# change ssh port
sed -i "s/#\?Port 22/Port $PORT/" "/etc/ssh/sshd_config"
if cat "/etc/issue" | grep -qF 'Ubuntu'; then
    service ssh restart
else
    service sshd restart
fi

# update
if cat "/etc/issue" | grep -qF 'Ubuntu'; then
    apt-get update -y
    apt-get upgrade -y
else
    yum -y update
fi

# change mta to postfix
if ! cat "/etc/issue" | grep -qF 'Ubuntu'; then
    service sendmail stop
    chkconfig sendmail off
    yum install -y postfix
    /usr/sbin/alternatives --set mta "/usr/sbin/sendmail.postfix"
    yum remove -y sendmail
    service postfix start
    chkconfig postfix on
fi

} | tee -a /root/install.log

