require 'spec_helper'

describe DB_Queue do
  it "can be instantiated" do
    db_queue = DB_Queue.new("start_queue")
    db_queue.should be_an_instance_of(DB_Queue)
  end
end
