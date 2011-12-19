require 'rubygems'
require "dbi"
require 'pg'

require_relative 'bc_queue.rb'
require_relative 'bc_element.rb'

   
class DB_Queue < BC_Queue
  
   
   def initialize(qname) 
     super(qname)
     @dbh = connect_db()
   end
 
   def add_tail(element)
     begin
	     puts "In add tail"
       sth = @dbh.prepare("SELECT uri, last_modified_date FROM data_hive.uri_queue WHERE uri = ?")
       sth.execute(element.uri)
       rows = sth.fetch_all      
       puts "column name size #{sth.column_names.size}"
       
       printf "Number of rows: %d\n", rows.size
       
       if( rows.size > 0 )
         puts "We found same node in the queue."
         sth.finish
       else
	       puts "We will add to db"
         sth.finish
         
         sth = @dbh.prepare("insert INTO data_hive.uri_queue( uri, last_modified_date ) VALUES ( ?, ?)")
         sth.execute(element.uri, element.last_modified)
         @dbh.commit
         
       end
       puts "finish all"
       rescue DBI::DatabaseError => e
         puts "An error occurred"
         puts "Error code:    #{e.err}"
         puts "Error message: #{e.errstr}"
         @dbh.rollback
       ensure
         puts "disconnect"
         # disconnect from server
         #@dbh.disconnect if @dbh
         #puts "disconnected"
     end
   end
   
   def remove_head()
     element = nil
     begin
       sth = @dbh.prepare("SELECT  uri, last_modified_date FROM data_hive.uri_queue order by last_modified_date desc limit 1")
       sth.execute()
      
       while row=sth.fetch do
         p row
         element = BC_Element.new( row[0], row[1] )
       end
       
       sth.finish
       if( element != nil)
         sth = @dbh.prepare("delete from data_hive.uri_queue WHERE uri = ?")
         sth.execute(element.uri)
         sth.finish
         @dbh.commit
       end 
       
       rescue DBI::DatabaseError => e
         puts "An error occurred"
         puts "Error code:    #{e.err}"
         puts "Error message: #{e.errstr}"
         @dbh.rollback
       ensure
         # disconnect from server
         #@dbh.disconnect if @dbh
     end
     
     return element
   end
   
   def uninit()
     disconnect_db()
     super.uninit()
   end
   
   def connect_db()
     puts "connect to db"
     return DBI.connect("dbi:Pg:dbname=mango_test;host=localhost", "myao", "db2")
   end
   
   def disconnect_db()
     @dbh.disconnect if @dbh
     @dbh = nil
   end
end
