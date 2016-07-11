FROM openmandriva/cooker
#FROM openmandriva/cooker-aarch64
#FROM openmandriva/cooker-armv7hl
# replace me with armv7hl, aarch64
ENV RARCH x86_64
ENV RUBY ruby-2.2.3

RUN urpmi --auto --auto-update --no-verify-rpm \
 && urpmi.addmedia contrib http://abf-downloads.openmandriva.org/cooker/repository/$RARCH/contrib/release/ \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
 && urpmi --no-suggests --no-verify-rpm --auto mock-urpm git curl sudo gnutar yaml-devel gcc-c++ readline-devel openssl-devel libtool bison\
 && sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
 && echo "%mock-urpm ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && adduser omv \
 && usermod -a -G mock-urpm omv \
 && chown -R omv:mock-urpm /etc/mock-urpm \
 && rm -rf /var/cache/urpmi/rpms/*

## put me in RUN if you have more than 16gb of RAM
# && echo "tmpfs /var/lib/mock-urpm/ tmpfs defaults,size=4096m,uid=$(id -u omv),gid=$(id -g omv),mode=0700 0 0" >> /etc/fstab \
#

ADD ./build-rpm.sh /mdv/build-rpm.sh
ADD ./config-generator.sh /mdv/config-generator.sh
ADD ./download_sources.sh /mdv/download_sources.sh
ADD ./cachedchroot.sh /mdv/cachedchroot.sh

USER omv
ENV HOME /home/omv

COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
