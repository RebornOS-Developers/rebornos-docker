FROM archlinux:base-devel

WORKDIR /home/rebornos-shared
ENV LANG=C.UTF-8
SHELL ["/bin/sh", "-c"]

COPY etc/ /etc/
COPY usr/ /usr/
RUN { groupadd wheel &> /dev/null || true; } \
    && useradd --create-home --groups wheel rebornos \
    && echo "rebornos ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && pacman-key --init \
    && pacman -Sy --noconfirm archlinux-keyring \
    && pacman -Sy --config /etc/pacman.conf.unsafe --noconfirm rebornos-keyring \
    && pacman-key --populate archlinux rebornos \
    && pacman -Syu --noconfirm rebornos-mirrorlist rebornos-os-release rebornos-logo rate-mirrors \
    && rm -rf \
        /etc/pacman.d/gnupg \
        /var/cache/pacman/pkg/ \
        /var/lib/pacman/sync/

CMD ["/usr/bin/init-rebornos-docker.sh"]
