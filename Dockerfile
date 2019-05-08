FROM alpine:3.9

ARG gpp
ENV gver=${gpp}

WORKDIR /home/dev/gcc-$gver

RUN apk add --no-cache build-base wget \
    # Download gcc from ftp.gnu.org/gnu/gcc/gcc-${version}
    && wget http://ftp.gnu.org/gnu/gcc/gcc-$gver/gcc-$gver.tar.bz2 \
    && tar --strip-components=1 -xjf gcc-$gver.tar.bz2 \
    && ./contrib/download_prerequisites \
    && mkdir build
WORKDIR /home/dev/gcc-$gver/build
RUN ../configure \
    --disable-nls         \
    --enable-languages=c++ \
    --disable-multilib

RUN make all -j $THREADS && make install

# Remove system g++, replacing it with the one created here
# Remove the gcc build folders and tar file
# Remove tools that are no longer necessary