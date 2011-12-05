

class BC_Element
  attr_accessor :uri, :last_modified
  
  def initialize(uri, last_modified) 
     @uri = uri
     @last_modified = last_modified
  end
end