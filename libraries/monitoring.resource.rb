#
# Cookbook Name:: monitoring
# Library::Monitoring Resource
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

require 'chef/resource'

require 'uri'

class Chef
  class Resource
    class Monitoring < Chef::Resource
      class Schedule
        class OneMinutes
        end
        class FiveMinutes
        end
        class TenMinutes
        end
        class FifteenMinutes
        end
        class ThirtyMinutes
        end
        class OneHour
        end
        class Custom
        end
      end

      @@elements = []

      def self.append(element)
        Monitoring.elements << element
      end
      def self.elements
        @@elements
      end

      def initialize(name, run_context=nil)
        super
        @resource_name = :monitoring
        @action = :create
        @allowed_actions = [ :create ]

        # Verify run_list is okay
        runlistc = RunListModifier.new(node.run_list)
        runlistc.unshift("recipe[monitoring::first]")
        runlistc.append("recipe[monitoring::last]")

        # Which schedule
        @schedule = Chef::Resource::Monitoring::Schedule::FifteenMinutes.new

        # Check parameters
        @scheme = 'void:///'
        @nagios_cmd = ''
        @nagios_parameters = []
        @nagios_rawcmd = ''

        @external = false
        @external_only = false
        @external_uri = 'void:///'
        @external_parameters = {}

        @status = true
      end

      def save!
        # Save element to attributes
        self.class.append(self.to_hash)
      end

      def to_hash
        content = {}
        content[:scheme] = @scheme

        content[:nagios_cmd] = @nagios_cmd if @nagios_cmd
        content[:nagios_parameters] = @nagios_parameters if @nagios_parameters
        content[:nagios_rawcmd] = @nagios_rawcmd if @nagios_rawcmd

        content[:external] = @external if @external
        content[:external_only] = @external_only if @external_only
        content[:external_uri] = @external_uri if @external_uri
        content[:external_parameters] = @external_parameters if @external_parameters

        content[:status] = @status if @status

        content[:name] = @name

        content
      end

      def scheme(arg)
        begin
          URI.parse(arg)
          @scheme = arg
        rescue URI::InvalidURIError
          raise ArgumentError, "scheme doesn't look like URI"
        end
      end

      def nagios_cmd(arg=nil)
        set_or_return(
          :nagios_cmd,
          arg,
          :kind_of => String
        )
      end

      def nagios_parameters(arg=nil)
        set_or_return(
          :nagios_parameters,
          arg,
          :kind_of => Array
        )
      end

      def nagios_rawcmd(arg=nil)
        set_or_return(
          :nagios_rawcmd,
          arg,
          :kind_of => Array
        )
      end

      def external(arg=nil)
        set_or_return(
          :external,
          arg,
          :kind_of => Boolean
        )
      end

      def external_only(arg=nil)
        set_or_return(
          :external_only,
          arg,
          :kind_of => Boolean
        )
      end

      def external_uri(arg)
        begin
          URI.parse(arg)
          @scheme = arg
        rescue URI::InvalidURIError
          raise ArgumentError, "scheme doesn't look like URI"
        end
      end

      def external_parameters(arg=nil)
        set_or_return(
          :external_parameters,
          arg,
          :kind_of => Hash
        )
      end

      def status(arg=nil)
        set_or_return(
          :status,
          arg,
          :kind_of => Boolean
        )
      end

    end
  end
end


#actions :create
#
#attribute :name, :kind_of => String, :name_attribute => true
#attribute :type, :kind_of => String
#
#attribute :nagios_cmd, :kind_of => String
#attribute :nagios_script, :kind_of => String
#attribute :nagios_parameters, :kind_of => Array, :default => []
#
#attribute :resolution, :kind_of => Monitor::Schedule
#
#attribute :external, :kind_of => Boolean
#attribute :external_only, :kind_of => Boolean
#attribute :external_uri, :kind_of => String
#attribute :external_parameters, :kind_of => Hash


