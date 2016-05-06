#!/usr/bin/env bash

DIR_HUAWEI=$DEST/networking-huawei

function install_networking_huawei {
    cd $DIR_HUAWEI
    sudo python setup.py install
    sudo pip install -r requirements.txt
}

if is_service_enabled huawei-ac; then

    if [[ "$1" == "source" ]]; then
        # no-op
        :   
    fi

    if [[ "$1" == "stack" && "$2" == "pre-install" ]]; then
        echo "Configuring Huawei AC"
    elif [[ "$1" == "stack" && "$2" == "install" ]]; then
        echo "Installing Huawei AC"
        install_networking_huawei
    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        echo "Post config Huawei AC"
    elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
        echo "Starting Huawei AC"
    fi

    if [[ "$1" == "unstack" ]]; then
        echo "Stop Huawei AC"
        cd $DIR_HUAWEI
        sudo pip uninstall -q -y networking-huawei
        sudo rm -r build networking_huawei.egg-info
    fi

    if [[ "$1" == "clean" ]]; then
        :
    fi
fi
