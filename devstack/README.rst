===========================================
 Enabling in DevStack for networking-huawei
===========================================

This directory contains the networking-huawei devstack plugin. To configure the networking huawei, you have to enable the networking-huawei devstack plugin by editing the [[local|localrc]] section of your local.conf file.

1) Download DevStack

     > git clone https://git.openstack.org/openstack-dev/devstack
2) Enable the plugin

To enable the plugin, add a line of the form:

     > enable_plugin networking-huawei <GITURL> [GITREF]

where

<GITURL> is the URL of a networking-huawei repository
[GITREF] is an optional git ref (branch/ref/tag).  The default is
         master.

For example

If you have already cloned the networking-huawei repository

     > enable_plugin networking-huawei /opt/stack/networking-huawei

Or, if you want to pull the networking-huawei repository from Github and use a particular branch (for example Liberty, here)

     > enable_plugin networking-huawei git://git.openstack.org/openstack/networking-huawei master

For more information, see the "Externally Hosted Plugins" section of http://docs.openstack.org/developer/devstack/plugins.html.

3) Start DevStack

     > ./stack.sh