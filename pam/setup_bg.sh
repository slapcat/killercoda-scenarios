# package management
apt update
apt install -y libpam-mount
DEBIAN_FRONTEND=noninteractive pam-auth-update --force
unlink /root/filesystem

# configure user-specific mounts
sed -i 's@</pam_mount>@<luserconf name=".pam_mount.conf.xml" /></pam_mount>@' /etc/security/pam_mount.conf.xml

# add users
useradd alice -p UqMv0m/vEZaYM -s /bin/bash -m
useradd bob -p kLGvLX79uepxo -s /bin/bash -m
useradd carol -p kWZWXO3IoO2jI -s /bin/bash -m
useradd diego -p YJwEpT5wG6Nwo -s /bin/bash -m

# update PAM files and relevant configs
cat <<EOF > /etc/security/faillock.conf
deny=1
unlock_time=0
audit
EOF
cat <<EOF > /etc/ssh/sshd_config
UsePAM yes
PasswordAuthentication yes
PermitRootLogin yes
EOF
rm /etc/ssh/sshd_config.d/50-cloud-init.conf
systemctl restart sshd
echo 'session	optional	pam_mount.so' >> /etc/pam.d/common-auth
sed -Ei 's/^auth.*success=1 default=ignore.*$/auth    [success=1 default=ignore]      pam_unix.so nullok\nauth    [success=1 default=ignore]      pam_localuser.so use_first_pass/' /etc/pam.d/common-auth
sed -Ei 's/@include common-auth/auth    required pam_faillock.so preauth\nauth    [success=1 default=ignore]      pam_unix.so nullok\nauth    [default=die] pam_faillock.so authfail\nauth    sufficient pam_faillock.so authsucc\naccount    required pam_faillock.so/' /etc/pam.d/sshd
sed -i 's/nosuid,nodev,loop,encryption,fsck,nonempty,allow_root,allow_other/*/' /etc/security/pam_mount.conf.xml
sed -i 's/enable="1"/enable="0"/' /etc/security/pam_mount.conf.xml

# add alice's flag
echo '"The only true wisdom is in knowing you know nothing." - Socrates' > /home/alice/alice.flag
chown alice:alice /home/alice/alice.flag

# setup encrypted volume
truncate -s 100M /opt/bob-encrypted.img
chown bob:bob /opt/bob-encrypted.img
echo -n "bob" | cryptsetup luksFormat /opt/bob-encrypted.img -
echo -n "bob" | cryptsetup luksOpen /opt/bob-encrypted.img ev -
mkfs.ext4 /dev/mapper/ev
mount /dev/mapper/ev /mnt
echo '"Education is bitter, but its fruit is sweet." - Aristotle' > /mnt/bob.flag
chown -R bob:bob /mnt
umount /mnt
cryptsetup luksClose ev

# add bob's automount file
cat <<EOF > /home/bob/.pam_mount.conf.xml
<pam_mount>
<volume user="bob" fstype="crypt" path="/opt/bob-encrypted.img" mountpoint="/root/private" options="nodev,nosuid,user=bob" />
</pam_mount>
EOF
chown bob:bob /home/bob/.pam_mount.conf.xml

# carol
echo 'carol            hard    maxlogins            1' >> /etc/security/limits.conf
echo '"The highest activity a human being can attain is learning for understanding, because to understand is to be free." - Baruch Spinoza' > /home/carol/carol.flag

# diego
echo "echo 'Quote of the Day: \"Life is not a problem to be solved, but a reality to be experienced.\" - Soren Kierkegeaard'" >> /home/diego/.profile

touch /tmp/finished

# create failures
tmux new-session -d bash
tmux split-window -h bash
tmux send -t 0:0.0 "ssh diego@localhost" C-m
tmux send -t 0:0.1 "login carol" C-m
sleep 1
tmux send -t 0:0.0 C-m
tmux send -t 0:0.1 "carol" C-m
sleep 1
tmux send -t 0:0.1 C-m
