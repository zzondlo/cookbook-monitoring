#
# Cookbook Name:: monitoring
# Library:: Run list modifier helper
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


class RunListModifier
  def initialize(run_list)
    @run_list = run_list
  end
  def unshift(item_name)
    item = Chef::RunList::RunListItem.new(item_name)
    if not self.class.in_first(@run_list.run_list, item)
      @run_list.remove(item)
      run_list = @run_list.run_list.clone

      # Set first one to item
      @run_list[0] = item_name

      # Loop over run_list to increment key
      key = 0
      run_list.each do |value|
        key += 1
        @run_list[key] = value.to_s
      end
    end
  end
  def append(item_name)
    item = Chef::RunList::RunListItem.new(item_name)
    if not self.class.in_last(@run_list.run_list, item)
      @run_list.remove(item)
      @run_list << item_name
    end
  end

  def self.in_first(run_list, item)
    run_list.each do |rli|
      return true if rli.name == item.name && rli.type == :recipe # Found it
      return false if not rli.name =~ /::first$/ or not rli.type == :recipe # Still in the first ones
    end
    return false
  end

  def self.in_last(run_list, item)
    run_list_reverse = run_list.reverse
    run_list.reverse.each do |rli|
      return true if rli.name == item.name && rli.type == :recipe # Found it
      return false if not rli.name =~ /::last$/ or not rli.type == :recipe # Still in the last ones
    end
    return false
  end
end
