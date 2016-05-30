#!/usr/bin/env bash

DIR_HUAWEI=$DEST/networking-huawei
NW_HUAWEI_AC_CONF_FILE=${NW_HUAWEI_AC_CONF_FILE:-"$NEUTRON_CONF_DIR/huawei_driver_config.ini"}


function configure_ac_driver {
    cp $DIR_HUAWEI/etc/huawei_driver_config.ini.sample $NW_HUAWEI_AC_CONF_FILE
}

#This API will be called for phase "post-config"
function ac_generate_config_files {
    (cd $DIR_HUAWEI && exec ./tools/generate_config_file_samples.sh)
}

function ac_post_configure {
    if is_service_enabled huawei-ac; then
        ac_generate_config_files
        configure_ac_driver
    fi
}

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
        ac_post_configure
    elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
        echo "Starting Huawei AC"
    fi

    if [[ "$1" == "unstack" ]]; then
        echo "Stop Huawei AC"
        cd $DIR_HUAWEI
        sudo pip uninstall -q -y networking-huawei
        sudo rm -rf build networking_huawei.egg-info
    fi

    if [[ "$1" == "clean" ]]; then
        cd $DEST
        sudo rm -rf networking_huawei

    fi
fi
