#using a centos base image
FROM centos:latest

#install sytemd and ssh
RUN yum install -y systemd openssh-server openssh-clients dbus nfs-utils munge munge-libs munge-devel rng-tools

RUN systemctl enable dbus

RUN mkdir -p /mnt/nfs/home
RUN mkdir -p /mnt/nfs/var/nfsshare
RUN mkdir -p /etc/munge/
RUN mkdir ~/.ssh/

RUN echo "password" | passwd --stdin root

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
