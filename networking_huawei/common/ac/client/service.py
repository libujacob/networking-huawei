# coding:utf-8
# Copyright (c) 2016 OpenStack Foundation.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

from networking_huawei.common.ac.client.restclient import RestClient
from oslo_config import cfg
from oslo_log import log as logging
import requests
import time

OPEN_ID = ''

LOG = logging.getLogger(__name__)


class RESTService(object):

    def __init__(self):
        self.host = cfg.CONF.ml2_huawei_ac.host
        self.port = cfg.CONF.ml2_huawei_ac.port
        self.serviceName = cfg.CONF.ml2_huawei_ac.service_name
        self.url = '%s%s%s%s' % ("http://", self.host, ":", str(self.port))

    def requestREST(self, method, url, id, body,
                    callBack=None):

        result = {}
        client = RestClient()
        result = client.send(
            self.host, self.port, method, url,
            id, body, callBack)
        return result

    def __logOff__(self, data, status, reason):
        self.__requestServiceParams__['success'](data, status, reason)

    def __logoffError__(self, status, reason):
        pass

    def requestService(self, method, url, id, body, isNeedServiceName=None,
                       callBack=None):
        LOG.debug('Request Service has been called.')
        result = {}
        client = RestClient()
        if isNeedServiceName is True:
            for key in body:
                body[key]["serviceName"] = self.serviceName
        self.__requestServiceParams__ = {
            "method": method,
            "url": '%s%s' % (self.url, url),
            "body": body,
            "id": id,
            "callBack": callBack
        }
        result = self.__doRequestSerive__(data='', status='', reason='')
        if client.http_success(result):
            LOG.debug('AC: request is success.')
        else:
            if (result['status'] == requests.codes.ok) and \
                result['response']['code'] == requests.codes.no_content:
                LOG.debug('AC:openid is invalid, get openid again.')

    def __doRequestSerive__(self, data, status, reason):

        result = {}

        result = self.requestREST(
            self.__requestServiceParams__['method'],
            self.__requestServiceParams__['url'],
            self.__requestServiceParams__['id'],
            self.__requestServiceParams__['body'],
            self.__requestServiceParams__['callBack'])

        return result

    def __doRequestServiceError__(self, status, reason):

        pass

    def reportOpenstackName(self):

        openstackInfo = {
            'neutron_name': cfg.CONF.ml2_huawei_ac.ac_neutron_name,
            'neutron_ip': cfg.CONF.ml2_huawei_ac.ac_neutron_ip
        }

        body = {
            "neutron_name": cfg.CONF.ml2_huawei_ac.ac_neutron_name,
            "neutron_ac_data": openstackInfo
        }

        self.requestService(
            "POST",
            "/rest/openapi/AgileController/OpenSDK/openstackname",
            {},
            body,
            self.__reportOpenstackNameSuccess__,
            self.__reportOpenstackNameError__)

    def __reportOpenstackNameSuccess__(self, data, status, reason):
        pass

    def __reportOpenstackNameError__(self, status, reason):

        time.sleep(int(cfg.CONF.ml2_huawei_ac.ac_interval))

        self.reportOpenstackName()
