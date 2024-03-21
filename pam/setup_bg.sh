# configure user-specific mounts
sed -i 's@</pam_mount>@<luserconf name=".pam_mount.conf.xml" /></pam_mount>@' /etc/security/pam_mount.conf.xml

# add users
useradd alice -p UqMv0m/vEZaYM -s /bin/bash -m
useradd bob -p kLGvLX79uepxo -s /bin/bash -m

# update PAM files
DEBIAN_FRONTEND=noninteractive pam-auth-update --force
sed -i 's/success=2/success=1/' /etc/pam.d/common-auth
cat <<EOF >> /etc/pam.d/common-auth
auth	optional	pam_mount.so
session	optional	pam_mount.so
EOF

# add alice's flag
echo '"The only true wisdom is in knowing you know nothing." - Socrates' > /home/alice/alice.flag
chown alice:alice /home/alice/alice.flag
chmod 750 -R /home/alice

# setup encrypted volume
truncate -s 100M /home/bob/encrypted.img
chown bob:bob /home/bob/encrypted.img
echo -n "bob" | cryptsetup luksFormat /home/bob/encrypted.img -
echo -n "bob" | cryptsetup luksOpen /home/bob/encrypted.img ev -
mkfs.ext4 /dev/mapper/ev
mount /dev/mapper/ev /mnt
echo '"Education is bitter, but its fruit is sweet." - Aristotle' > /mnt/bob.flag
umount /mnt
cryptsetup luksClose ev

# add bob's automount file
cat <<EOF > /home/bob/.pam_mount.conf.xml
<pam_mount>
<volume user="bob" fstype="crypt" path="/home/bob/encrypted.img" mountpoint="/root/private" options="nodev,nosuid" />
</pam_mount>
EOF
chown bob:bob /home/bob/.pam_mount.conf.xml

# package management
unlink /root/filesystem
rm `which sudo` `which apt` `which su`
