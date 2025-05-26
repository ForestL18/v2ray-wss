##!/bin/sh
# Issues https://1024.day

if [[ $EUID -ne 0 ]]; then
    clear
    echo "Error: This script must be run as root!"
    exit 1
fi

cat >/etc/security/limits.conf<<EOF
* soft     nproc          655360
* hard     nproc          655360
* soft     nofile         655360
* hard     nofile         655360

root soft     nproc          655360
root hard     nproc          655360
root soft     nofile         655360
root hard     nofile         655360

bro soft     nproc          655360
bro hard     nproc          655360
bro soft     nofile         655360
bro hard     nofile         655360
EOF

echo "session required pam_limits.so" >> /etc/pam.d/common-session

echo "session required pam_limits.so" >> /etc/pam.d/common-session-noninteractive

echo "DefaultLimitNOFILE=655360" >> /etc/systemd/system.conf

cat >/etc/sysctl.conf<<EOF
fs.file-max = 655360
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
net.ipv4.tcp_slow_start_after_idle = 0
#net.ipv4.tcp_mtu_probing = 1
net.core.rmem_max=16777216
net.core.wmem_max=16777216
#net.ipv4.tcp_rmem=4096 87380 6291456
#net.ipv4.tcp_wmem=4096 65536 6291456
net.ipv4.tcp_rmem = 4096 87380 13125000
net.ipv4.tcp_wmem = 4096 65536 13125000
#net.ipv4.udp_rmem_min = 8192
#net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_adv_win_scale = -2
net.ipv4.tcp_notsent_lowat = 131072
#net.netfilter.nf_conntrack_max = 262144
#net.ipv4.tcp_tw_reuse = 1
#net.ipv4.tcp_fin_timeout = 15
#net.ipv4.ip_local_port_range = 10240 65535
#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1
EOF

rm tcp-window.sh

#sleep 3 && reboot >/dev/null 2>&1