module Mrg
  module Grid
    module Config
      module ArcUtils
        
        # * command is the "modify" command passed in from the tool
        # * dests is the set of keys for the input set
        # * options are provided by the tool
        # * getmsg is the message to get the current set of arcs
        # * setmsg is the message to set the current set of arcs
        # * explain is a string describing the relationship modeled by the arc (for error messages)
        # * keymsg is the message to get the key value from self
        def modify_arcs(command,dests,options,getmsg,setmsg,explain="have an arc to",keymsg=:name,what=nil)
          what ||= self.class.name.split("::").pop.downcase
          case command
          when "ADD" then 
            old_dests = Set[*self.send(getmsg)]
            new_dests = Set[*dests.keys]
            raise ArgumentError.new("#{what} #{name} cannot #{explain} itself") if new_dests.include? self.send(keymsg)
            self.send(setmsg, (old_dests + new_dests).to_a)
          when "REPLACE" then 
            new_dests = Set[*dests.keys]
            raise ArgumentError.new("#{what} #{name} cannot #{explain} itself") if new_dests.include? self.send(keymsg)
            self.send(setmsg, new_dests.to_a)
          when "UNION", "REMOVE", "INTERSECT", "DIFF" then
            raise RuntimeError.new("#{command} not implemented")            
          else nil
          end
        end
        
        def find_arcs(arc_class,label)
          arc_class.find_by(:source=>self, :label=>label).map do |arc|
            if block_given? 
              yield arc 
            else
              arc
            end
          end
        end
        
        def set_arcs(arc_class, label, dests, keyfindmsg, options=nil)
          options ||= {}
          what = options[:what] or self.class.name.split("::").pop.downcase
          dests = Set[*dests] unless options[:preserve_ordering]
          
          target_params = dests.map do |key|
            dest = self.class.send(keyfindmsg, key)
            raise ArgumentError.new("#{key} is not a valid #{what} key") unless dest
            dest
          end
          
          arc_class.find_by(:source=>self, :label=>label).map {|p| p.delete }
          
          target_params.each do |dest|
            arc_class.create(:source=>self.row_id, :dest=>dest.row_id, :label=>label.row_id)
          end
          
          dests.to_a
        end
        
      end
    end
  end
end