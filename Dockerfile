ARG AL_VERSION
FROM amazonlinux:${AL_VERSION}

ENV container docker

RUN set -eux; yum -y update; yum clean all  # (OPTION)
RUN set -eux; yum -y install systemd; yum clean all; \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);

RUN set -eux; \
	rm -f /lib/systemd/system/graphical.target.wants/*;\
	rm -f /lib/systemd/system/rescue.target.wants/*;\
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

CMD [ "/sbin/init" ] # init is symlinked to systemd
STOPSIGNAL SIGRTMIN+3 # Seems required for graceful stop of systemd

# ----------------------------------------------------------------------
# additional packages
RUN set -eux; \
    yum -y install procps psmisc less; \
	yum clean all
