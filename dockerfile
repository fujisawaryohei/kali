# 参考: https://zenn.dev/dev_zacker/articles/c42faf432278dc

FROM kalilinux/kali-rolling

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-headless 

RUN apt update && apt install -y \
    kali-defaults \
    kali-tools-web \
    kali-desktop-xfce \
    x11vnc \
    xvfb \
    novnc \
    dbus-x11 \
    tigervnc-standalone-server \
    burpsuite

# WireShark GUI用パッケージ
RUN apt update && apt install -y \
    libxcb-cursor0 \
    libxcb-keysyms1 \
    qt5-qmltooling-plugins \
    qtwayland5 \
    libqt5gui5

RUN apt update && apt install -y \
    neovim \
    htop \
    fish \
    inetutils-ping

# VPN用のディレクトリを作成
RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun

# 環境変数の設定
ENV DISPLAY=:1

# ユーザーの追加
RUN useradd -m -s /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali

# ユーザーの切り替え
USER kali

# ユーザーのホームディレクトリに移動
WORKDIR /home/kali

# VNCの設定
RUN mkdir -p /home/kali/.vnc && \
touch /home/kali/.Xauthority && \
chown -R kali:kali /home/kali/.Xauthority /home/kali/.vnc

# VNCの設定
RUN echo "kali:kali" | vncpasswd -f > /home/kali/.vnc/passwd && \
chmod 600 /home/kali/.vnc/passwd
