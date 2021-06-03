#!/usr/bin/env bash
set -eo pipefail

function setup_linux () {
    sudo apt-get install -y --no-install-recommends musl-tools
    case $(go env GOARCH) in
        amd64)
            rustup target add x86_64-unknown-linux-musl
            ;;
        arm64)
            rustup target add aarch64-unknown-linux-musl
            ;;
        *)
            >&2 echo Error: unsupported arch $(go env GOARCH)
            exit 1
            ;;
    esac
}

function setup_windows () {
    choco install mingw
    rustup target add x86_64-pc-windows-gnu
}

function main () {
    case $(go env GOOS) in
        linux)
            setup_linux
            ;;
        darwin)
            ;;
        windows)
            setup_windows
            ;;
        *)
            >&2 echo Error: unsupported OS $(go env GOOS)
            exit 1
            ;;
    esac
}

main ${@}
