require 'spec_helper'

describe DB_Queue do
  it "can be instantiated" do
    db_queue = DB_Queue.new("start_queue")
    db_queue.should be_an_instance_of(DB_Queue)
    db_queue.uninit()
  end
  
  it "can add tail" do
    db_queue = DB_Queue.new("start_queue")
    xe = BC_Element.new("www.google.com", 12-31-2011)
    db_queue.add_tail( xe )
    ele = db_queue.remove_head()
    ele.uri.should == "www.google.com"
    db_queue.uninit()
  end
end
