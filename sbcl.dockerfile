FROM debian:7.8
MAINTAINER Chris Gateley <me@cgateley.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -q -y

RUN /usr/sbin/locale-gen de_DE.UTF-8 && \
    update-locale LANG=de_DE.UTF-8

RUN apt-get install -q -y make wget bzip2 && \ 
    apt-get clean

ENV HOME /root
WORKDIR /tmp

# Download and install SBCL
RUN wget http://downloads.sourceforge.net/project/sbcl/sbcl/1.2.8/sbcl-1.2.8-x86-64-linux-binary.tar.bz2 -O sbcl.tar.bz2 && \
    mkdir sbcl && \
    tar jxvf sbcl.tar.bz2 --strip-components=1 -C sbcl && \
    cd sbcl && \
    sh install.sh && \
    cd .. && \
    rm -rf sbcl sbcl.tar.bz2

WORKDIR /root

# Download and install QuickLisp
RUN wget http://beta.quicklisp.org/quicklisp.lisp && \
    touch install.lisp && \
    echo '(load "quicklisp.lisp")' >> install.lisp && \
    echo '(quicklisp-quickstart:install)' >> install.lisp && \
    #echo '(ql:add-to-init-file)' >> install.lisp && \
    sbcl --non-interactive --load install.lisp

RUN touch .sbclrc && \
    echo '#-quicklisp' >> .sbclrc && \
    echo '(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"' >> .sbclrc && \
    echo '                                       (user-homedir-pathname))))' >> .sbclrc && \
    echo '  (when (probe-file quicklisp-init)' >> .sbclrc && \
    echo '    (load quicklisp-init)))' >> .sbclrc && \
    sbcl --non-interactive --quit

