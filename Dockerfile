FROM nvidia/cuda:10.1-devel-ubuntu16.04
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

COPY ./sources.list /etc/apt/sources.list
WORKDIR /tmp
RUN rm -rf /var/lib/apt/lists \
    && apt-get clean \
    && apt update \
    && apt-get install -y git libopenjp2* build-essential apt-utils yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev frei0r-plugins-dev libgnutls28-dev libass-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenjpeg-dev libopus-dev librtmp-dev libsoxr-dev libspeex-dev libtheora-dev libvo-amrwbenc-dev libvorbis-dev libvpx-dev libwebp-dev libx264-dev libx265-dev libxvidcore-dev
RUN ldconfig \
    && git clone https://github.com/FFmpeg/nv-codec-headers.git \
    && cd /tmp/nv-codec-headers \
    && git checkout sdk/9.0 \
    && make -j8 \
    && make install -j8 \
    && cd /tmp \
    && git clone https://gitee.com/bingoku/FFmpeg.git \
    && cd /tmp/FFmpeg \
    && git checkout release/4.2 \
    && cd /tmp/FFmpeg \
    && ldconfig \
    && ./configure \
    --enable-nonfree \
    --disable-shared \
    --enable-nvenc \
    --enable-cuda \
    --enable-cuvid \
    --enable-cuda-sdk \
    --enable-filter=scale_cuda \
    --enable-filter=thumbnail_cuda \
    --enable-libnpp \
    --extra-cflags=-Ilocal/include \
    --enable-gpl --enable-version3 \
    --disable-debug \
    --disable-ffplay \
    --disable-indev=sndio \
    --disable-outdev=sndio \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-gnutls \
    --enable-gray \
    --enable-libass \
    --enable-libfreetype \
    --enable-libfribidi \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-librtmp \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --extra-cflags=-I/usr/local/include \
    --extra-cflags=-I/tmp/FFmpeg/include \
    --extra-cflags=-I/tmp/FFmpeg/lib \
    && make -j8 \
    && make install -j8 \
    && rm -rf /tmp/nv-codec-headers \
    && rm -rf /tmp/FFmpeg
