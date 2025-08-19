##!/bin/sh
# Issues https://1024.day

if [[ $EUID -ne 0 ]]; then
    clear
    echo "Error: This script must be run as root!"
    exit 1
fi

cat >/etc/security/limits.conf<<EOF
* soft     nproc    131072
* hard     nproc    131072
* soft     nofile   262144
* hard     nofile   262144

root soft  nproc    131072
root hard  nproc    131072
root soft  nofile   262144
root hard  nofile   262144
EOF

echo "session required pam_limits.so" >> /etc/pam.d/common-session

echo "session required pam_limits.so" >> /etc/pam.d/common-session-noninteractive

echo "DefaultLimitNOFILE=262144" >> /etc/systemd/system.conf

echo "DefaultLimitNPROC=131072" >> /etc/systemd/system.conf

cp /etc/sysctl.conf /etc/sysctl.conf.bak.$(date +%F-%T)

cat >/etc/sysctl.conf<<EOF
fs.file-max = 524288

fs.file-max = 524288
net.core.default_qdisc = fq
net.core.somaxconn = 4096
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_congestion_control = bbr
net.core.rmem_max = 67108848
net.core.wmem_max = 67108848
#net.ipv4.tcp_rmem = 8192 262144 536870912
#net.ipv4.tcp_wmem = 4096 16384 536870912
net.ipv4.tcp_rmem = 8192 262144 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_adv_win_scale = -2
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_notsent_lowat = 131072
net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 1
kernel.panic = -1
vm.swappiness = 0

#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1
EOF

rm tcp-window.sh

#sleep 3 && reboot >/dev/null 2>&1
