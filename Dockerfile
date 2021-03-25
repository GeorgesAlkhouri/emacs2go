# Inspired by
# https://www.masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV JOBS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y

# Install requirements
# Do not use pkg-config
# libjansson4 for fast JSON
RUN apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common \
        openssh-server \
        libjansson4 libjansson-dev \
        vim git

# Install X2Go server
RUN add-apt-repository ppa:x2go/stable
RUN apt-get update -y
RUN apt-get install -y x2goserver x2goserver-xsession



# Get deps for Emacs
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get build-dep -y emacs

# Build and install Emacs
RUN wget https://ftp.gnu.org/gnu/emacs/emacs-27.1.tar.xz
RUN tar -xf emacs-27.1.tar.xz

WORKDIR /emacs-27.1

RUN ./autogen.sh && ./configure --with-x-toolkit=lucid --with-cairo --with-mailutils

RUN make -j ${JOBS} && make install

WORKDIR /

# Install Spacemacs
#RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d


# SSH runtime
RUN mkdir /var/run/sshd

# Configure root password
# TODO make this safer (add private key?)
RUN echo "root:SuperSecureRootPassword" | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

EXPOSE 22

COPY run.sh /run.sh
CMD ["/run.sh"]
