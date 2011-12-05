require_relative 'base_class.rb'

class BC_Queue 
   attr_accessor :qname
   
   def initialize(qname) 
     @qname = qname
   end
   
   def to_s
     @qname
   end
   
   def add_tail(element)
     raise Exception.new("This method is not implemented. - addTail ")
   end
   
   def remove_head()
     raise Exception.new("This method is not implemented. removeHead")
     return nil
   end
   
   def unini()
   end
end

