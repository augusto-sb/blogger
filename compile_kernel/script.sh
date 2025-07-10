docker image build . --tag chustos.io/linux/linux:6.12.37 --file Dockerfile --build-arg VERSION=6.12.37;

# https://discourse.ubuntu.com/t/kernel-configuration-in-ubuntu/35857
# https://www.debian.org/doc/manuals/debian-kernel-handbook/ch-common-tasks.html
# https://wiki.debian.org/BuildADebianKernelPackage

id=$(docker container run --rm --detach chustos.io/linux/linux:6.12.37 tail -f /dev/null);
docker container cp $id:/mykernel/linux-headers-6.12.37augusto_6.12.37-1_amd64.deb .
docker container cp $id:/mykernel/linux-image-6.12.37augusto_6.12.37-1_amd64.deb .
docker container cp $id:/mykernel/linux-libc-dev_6.12.37-1_amd64.deb .
docker container stop $id;

# sudo dpkg -i *.deb

# sudo nano /etc/default/grub
#GRUB_TIMEOUT_STYLE=menu
#GRUB_TIMEOUT=5
# sudo update-grub

rm *.deb