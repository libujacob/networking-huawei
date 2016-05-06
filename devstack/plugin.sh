#!/usr/bin/env bash

DIR_HUAWEI=$DEST/networking-huawei

if is_service_enabled net-huawei; then

    if [[ "$1" == "source" ]]; then
        # no-op
        :   
    fi

    if [[ "$1" == "stack" && "$2" == "pre-install" ]]; then
        echo "Pre-install Huawei AC"
    elif [[ "$1" == "stack" && "$2" == "install" ]]; then
        echo "Installing Huawei AC"
    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        echo "Post config Huawei AC"
    elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
        echo "Starting Huawei AC"
    fi

    if [[ "$1" == "unstack" ]]; then
        echo "Stop Huawei AC"
    fi

    if [[ "$1" == "clean" ]]; then
        :
    fi
fi
