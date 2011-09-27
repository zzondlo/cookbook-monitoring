

#
# Cookbook Name:: monitoring
# Definition::Monitoring_ssh
#
# Author:: Arthur Gautier <aga@zenexity.com>
# Copyright 2011, Zenexity, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
define :monitoring_ssh do
  monitoring params[:name] do
    schedule params[:schedule] if params[:schedule]

    scheme "ssh://#{node.fqdn}" if not params[:scheme]
    scheme params[:scheme] if params[:scheme]

    # Handle command
    nagios_cmd "check_ssh"

    # Handle parameters
    parameters = []
    parameters << params[:nagios_parameters] if params[:nagios_parameters]
    parameters << "$HOSTADDRESS$" if not params[:nagios_parameters]
    nagios_parameters parameters

    # Handle externals
    external false
    external params[:external] if params[:external]

    external_only false
    external_only params[:external_only] if params[:external_only]

    external_uri "ssh://#{node.fqdn}"
    external_uri params[:scheme] if params[:scheme]
    external_uri params[:external_uri] if params[:external_uri]

    external_parameters params[:external_parameters] if params[:external_parameters]

    status true
    status params[:status] if params[:status]
  end
  
end
