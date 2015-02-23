# CCL Version 1.9

FROM debian:7.8
MAINTAINER Chris Gateley <me@cgateley.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -q -y

RUN apt-get install -q -y wget && \ 
    apt-get clean

ENV HOME /root

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src/

# Download CCL
RUN wget http://ccl.clozure.com/ftp/pub/release/1.9/ccl-1.9-linuxx86.tar.gz -O ccl.tar.gz && \
    mkdir ccl && \
    tar xvf ccl.tar.gz --strip-components=1 -C ccl && \
    rm ccl.tar.gz && \
    find . -type d -name '.svn' -exec rm -rf {} \+ && \
    ln -s "$(pwd)/ccl/scripts/ccl64" /usr/local/bin

WORKDIR /root

# Download and install QuickLisp
RUN wget http://beta.quicklisp.org/quicklisp.lisp && \
    touch install.lisp && \
    echo '(load "quicklisp.lisp")' >> install.lisp && \
    echo '(quicklisp-quickstart:install)' >> install.lisp && \
    #echo '(ql:add-to-init-file)' >> install.lisp && \
    ccl64 --load install.lisp && \
    rm install.lisp

RUN touch ccl-init.lisp && \
    echo '#-quicklisp' >> ccl-init.lisp && \
    echo '(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"' >> ccl-init.lisp && \
    echo '                                       (user-homedir-pathname))))' >> ccl-init.lisp && \
    echo '  (when (probe-file quicklisp-init)' >> ccl-init.lisp && \
    echo '    (load quicklisp-init)))' >> ccl-init.lisp && \
    ccl64 -e "(ccl:quit)"
