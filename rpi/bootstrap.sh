#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SRC_VERSION=${1-}

function installService() {
    if [[ ! -f ~/.local/share/systemd/user/ssl-status-board.service ]]; then
        mkdir -p ~/.local/share/systemd/user/
        cp "$SCRIPT_DIR/ssl-status-board.service" ~/.local/share/systemd/user/ssl-status-board.service
        systemctl --user enable ssl-status-board.service
    fi
}

function installStatusBoard() {
    sudo apt-get install --no-install-recommends -y curl jq

    systemctl --user stop ssl-status-board.service
    mkdir -p ~/.local/bin/
    if [[ -z "${SRC_VERSION}" ]]; then
        SRC_VERSION="$(curl -s https://api.github.com/repos/RoboCup-SSL/ssl-status-board/releases/latest | jq -r '.tag_name')"
    fi
    echo "Installing version: ${SRC_VERSION}"
    wget "https://github.com/RoboCup-SSL/ssl-status-board/releases/download/${SRC_VERSION}/ssl-status-board_${SRC_VERSION}_linux_arm" -O ~/.local/bin/ssl-status-board
    chmod +x ~/.local/bin/ssl-status-board
    systemctl --user start ssl-status-board.service
}

function installBrowser() {
    # https://blog.r0b.io/post/minimal-rpi-kiosk/
    sudo apt-get install --no-install-recommends -y \
        xserver-xorg-video-all xserver-xorg-input-all xserver-xorg-core xinit x11-xserver-utils \
        unclutter \
        chromium-browser

    # Enable Auto-Login on console
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    sudo cp "${SCRIPT_DIR}/autologin.conf" /etc/systemd/system/getty@tty1.service.d/autologin.conf

    # Configure to run browser when X starts
    cp "${SCRIPT_DIR}/.xinitrc" ~/.xinitrc

    # Configure to run X on tty1
    cp "${SCRIPT_DIR}/.bash_profile" ~/.bash_profile
}

sudo apt-get update
installService
installStatusBoard
installBrowser
