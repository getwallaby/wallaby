#!/usr/bin/env ruby

# activate:  wallaby shell command to activate current changes to the configuration
#
# Copyright (c) 2009--2010 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Mrg
  module Grid
    module Config
      module Shell
        class Activate < Command
          def self.opname
            "activate"
          end

          def self.description
            "Activates pending changes to the pool configuration."
          end
          
          def act
            explain = @store.activateConfig
            if explain != {}
              puts "Failed to activate configuration; please correct the following errors."
              explain.each do |node, node_explain|
                puts "#{node}:"
                node_explain.each do |reason, ls|
                  puts "  #{reason}: #{ls.inspect}"
                end
              end
              return 1
            end
            0
          end
        end
      end
    end
  end
end
