#
# Cookbook Name:: monitoring
# Library::Monitoring Provider
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

require 'chef/log'
require 'chef/provider'
require 'chef/mixin/language_include_attribute'

class Chef
  class Provider
    class Monitoring < Chef::Provider
      include Chef::Mixin::LanguageIncludeAttribute

      def load_current_resource
        # No real need for current_resource state, we're just putting everything
        # again in couch db

        @current_resource = Chef::Resource::Monitoring.new(@new_resource.name)
        @current_resource
      end

      def action_create
        @node = node

        include_attribute 'monitoring'

        # Verify run_list is okay
        runlistc = RunListModifier.new(node.run_list)
        runlistc.unshift("recipe[monitoring::first]")
        runlistc.append("recipe[monitoring::last]")

        # Register element
        @new_resource.save!
      end
    end
  end
end
