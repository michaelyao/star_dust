require 'spec_helper'

describe DB_Queue do
  it "can be instantiated" do
    db_queue = DB_Queue.new("start_queue")
    #db_queue.uninit()
    db_queue.should be_an_instance_of(DB_Queue)
    
  end
  
  it "can add tail" do
    db_queue = DB_Queue.new("start_queue")
    xe = BC_Element.new("www.facebook.com", '1-3-2012')
    db_queue.add_tail( xe )
    ele = db_queue.remove_head()
    #db_queue.uninit()
    ele.uri.should == "www.facebook.com"
    
  end
end
