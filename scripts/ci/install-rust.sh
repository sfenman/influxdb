#!/usr/bin/env bash
set -eo pipefail

function install_linux_target () {
    case $(dkpg --print-architecture) in
        amd64)
            rustup target add x86_64-unknown-linux-musl
            ;;
        arm64)
            rustup target add aarch64-unknown-linux-musl
            ;;
        *)
            >&2 echo Error: unknown arch $(dpkg --print-architecture)
            exit 1
            ;;
    esac
}

function install_windows_target () {
    rustup target add x86_64-pc-windows-gnu
}

function main () {
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
    case $(uname) in
        Linux)
            install_linux_target
            ;;
        Darwin)
            ;;
        MSYS_NT*)
            install_windows_target
            ;;
        *)
            >&2 echo Error: unknown OS $(uname)
            exit 1
            ;;
    esac

    ${HOME}/.cargo/bin/rustup --version
}

main ${@}
