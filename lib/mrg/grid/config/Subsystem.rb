require 'spqr/spqr'
require 'rhubarb/rhubarb'

module Mrg
  module Grid
    module Config
      class Subsystem
        include ::Rhubarb::Persisting
        include ::SPQR::Manageable

        qmf_package_name 'mrg.grid.config'
        qmf_class_name 'Subsystem'
        ### Property method declarations
        # property name sstr 

        declare_column :name, :string, :not_null
        declare_index_on :name
        
        qmf_property :name, :sstr, :index=>true
        ### Schema method declarations
        
        # GetParams 
        # * params (map/O)
        #   A set of parameter names that the subsystem is interested in
        def GetParams()
          # Assign values to output parameters
          params ||= {}
          # Return value
          return params
        end
        
        expose :GetParams do |args|
          args.declare :params, :map, :out, {}
        end
        
        # ModifyParams 
        # * command (sstr/I)
        #   Valid commands are 'ADD', 'REMOVE', 'UNION', 'INTERSECT', 'DIFF', and 'REPLACE'.
        # * params (map/I)
        #   A set of parameter names
        def ModifyParams(command,params)
          # Print values of input parameters
          log.debug "ModifyParams: command => #{command}"
          log.debug "ModifyParams: params => #{params}"
        end
        
        expose :ModifyParams do |args|
          args.declare :command, :sstr, :in, {}
          args.declare :params, :map, :in, {}
        end
      end
    end
  end
end
