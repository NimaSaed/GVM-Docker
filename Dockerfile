FROM ubuntu:20.10

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -yq --no-install-recommends \
    gnupg \
    bison \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gcc \
    gcc-mingw-w64 \
    geoip-database \
    gnutls-bin \
    graphviz \
    heimdal-dev \
    ike-scan \
    libgcrypt20-dev \
    libglib2.0-dev \
    libgnutls28-dev \
    libgpgme11-dev \
    libgpgme-dev \
    libhiredis-dev \
    libical-dev \
    libksba-dev \
    libldap2-dev \
    libmicrohttpd-dev \
    libnet-snmp-perl \
    libpcap-dev \
    libpopt-dev \
    libsnmp-dev \
    libssh-gcrypt-dev \
    libxml2-dev \
    net-tools \
    nmap \
    nsis \
    openssh-client \
    openssh-server \
    perl-base \
    pkg-config \
    postfix \
    postgresql-12 \
    postgresql-server-dev-12 \
    python3-defusedxml \
    python3-dialog \
    python3-lxml \
    python3-paramiko \
    python3-pip \
    python3-polib \
    python3-psutil \
    python3-setuptools \
    redis-server \
    redis-tools \
    rsync \
    smbclient \
    sshpass \
    texlive-fonts-recommended \
    texlive-latex-extra \
    uuid-dev \
    wapiti \
    wget \
    whiptail \
    xml-twig-tools \
    xsltproc \
    libradcli-dev \
    fakeroot \
    libnet1-dev \
    libunistring-dev \
    python3-dev \
    rpm \
    git \
    doxygen

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install nodejs -yq --no-install-recommends

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install yarn -yq --no-install-recommends

RUN rm -rf /var/lib/apt/lists/*

ENV gvm_libs_version="v21.4.0" \
    openvas_scanner_version="v21.4.0" \
    pggvm_version="fa973261bee877590e0d0096eb0f9213a38a7965" \
    gvmd_version="v21.4.0" \
    gsa_version="v21.4.0" \
    gvm_tools_version="v21.1.0" \
    openvas_smb="v21.4.0" \
    open_scanner_protocol_daemon="v21.4.0" \
    ospd_openvas="v21.4.0" \
    python_gvm_version="v21.4.0"

    #
    # install libraries module for the Greenbone Vulnerability Management Solution
    #

RUN mkdir /build && \
    cd /build && \
    echo "wget version:" && \
    cat /etc/os-release && \
    uname -a && \
    /usr/bin/wget --version && \
    echo "wget version done" && \
    wget --no-verbose https://github.com/greenbone/gvm-libs/archive/$gvm_libs_version.tar.gz && \
    tar -zxf $gvm_libs_version.tar.gz && \
    cd /build/*/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /build

    #
    # install smb module for the OpenVAS Scanner
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/openvas-smb/archive/$openvas_smb.tar.gz && \
    tar -zxf $openvas_smb.tar.gz && \
    cd /build/*/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /build

    #
    # Install Greenbone Library for GVM helper functions in PostgreSQL
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/pg-gvm/archive/$pggvm_version.tar.gz && \
    tar -zxf $pggvm_version.tar.gz && \
    cd /build/*/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /build

    #
    # Install Greenbone Vulnerability Manager (GVMD)
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/gvmd/archive/$gvmd_version.tar.gz && \
    tar -zxf $gvmd_version.tar.gz && \
    cd /build/*/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /build

    #
    # Install Open Vulnerability Assessment System (OpenVAS) Scanner of the Greenbone Vulnerability Management (GVM) Solution
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/openvas-scanner/archive/$openvas_scanner_version.tar.gz && \
    tar -zxf $openvas_scanner_version.tar.gz && \
    cd /build/*/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /build

    #
    # Install Greenbone Security Assistant (GSA)
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/gsa/archive/$gsa_version.tar.gz && \
    tar -zxf $gsa_version.tar.gz && \
    cd /build/*/ && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    cd / && \
    rm -rf /build

    #
    # Install Greenbone Vulnerability Management Python Library
    #

RUN pip3 install python-gvm==$python_gvm_version

    #
    # Install Open Scanner Protocol daemon (OSPd)
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/ospd/archive/$open_scanner_protocol_daemon.tar.gz && \
    tar -zxf $open_scanner_protocol_daemon.tar.gz && \
    cd /build/*/ && \
    python3 setup.py install && \
    cd / && \
    rm -rf /build

    #
    # Install Open Scanner Protocol for OpenVAS
    #

RUN mkdir /build && \
    cd /build && \
    wget --no-verbose https://github.com/greenbone/ospd-openvas/archive/$ospd_openvas.tar.gz && \
    tar -zxf $ospd_openvas.tar.gz && \
    cd /build/*/ && \
    python3 setup.py install && \
    cd / && \
    rm -rf /build

    #
    # Install GVM-Tools
    #

RUN pip3 install gvm-tools==$gvm_tools_version && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/openvas.conf && ldconfig && cd / && rm -rf /build

COPY report_formats/* /report_formats/

COPY greenbone-feed-sync-patch.txt /greenbone-feed-sync-patch.txt

RUN patch /usr/local/sbin/greenbone-feed-sync /greenbone-feed-sync-patch.txt

COPY sshd_config /sshd_config

COPY scripts/* /

CMD '/start.sh'
