require_relative 'db_queue.rb'
require_relative 'bc_element.rb'
db_queue = DB_Queue.new("start_queue")
puts "add tail"
elem = BC_Element.new("http://www.google.com", '2011-11-11')
db_queue.add_tail(elem)
