FROM ccl:1.9
MAINTAINER Chris Gateley <me@cgateley.com>

WORKDIR /root

# Load racer automatically with CCL
RUN echo '' >> ccl-init.lisp && \
    echo '#-racer' >> ccl-init.lisp && \
    echo '(ql:quickload "racer")' >> ccl-init.lisp && \
    # Run once to download and compile dependencies (this can take a few minutes)
    ccl64 -e "(ccl:quit)"

# HTTP service
EXPOSE 8080
# TCP service
EXPOSE 8088
# TCP control
EXPOSE 8089

CMD ccl64 --eval "(racer:racer-toplevel)"

