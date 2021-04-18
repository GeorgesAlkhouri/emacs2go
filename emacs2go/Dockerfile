# Inspired by
# https://www.masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation

FROM silex/emacs:master
ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y

# Install requirements
RUN apt-get install -y \
        software-properties-common \
        openssh-server \
        vim git

# Install X2Go server
RUN add-apt-repository ppa:x2go/stable
RUN apt-get update -y
RUN apt-get install -y x2goserver x2goserver-xsession

# SSH runtime
RUN mkdir /var/run/sshd

# Configure root password
# TODO make this safer (add private key?)
RUN echo "root:SuperSecureRootPassword" | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

EXPOSE 22

COPY run.sh /run.sh
CMD ["/run.sh"]
