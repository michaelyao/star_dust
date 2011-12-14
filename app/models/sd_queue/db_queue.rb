require 'rubygems'
require "dbi"
require 'pg'

require_relative 'bc_queue.rb'


   
class DB_Queue < BC_Queue
  
   
   def initialize(qname) 
     super(qname)
     @dbh = connect_db()
   end
 
   def add_tail(element)
     begin
	     puts "In add tail"
       sth = @dbh.prepare("SELECT uri, last_modified_date FROM data_hive.uri_queue WHERE uri = ?")
	     puts "after prepare"

       sth.execute(element.uri)
       puts "after excute"
       puts sth.to_s()
       
       if( sth.count > 0 )
         puts "finish 1"
         sth.finish
       else
	       puts "finish 2"
         sth.finish
         puts "sth.count"
         sth = @dbh.prepare("insert INTO data_hive.uri_queue( uri, last_modified_date ) VALUES ( ?, ?)")
         sth.execute(element.uri, element.last_modified)
         sth.finish
         @dbh.commit
         puts "add data"
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
         @dbh.disconnect if @dbh
         puts "disconnected"
     end
   end
   
   def remove_head()
     element = nil
     begin
       sth = @dbh.prepare("SELECT top 1 uri, last_modified_date FROM data_hive.uri_queue order by last_modified desc")
       sth.execute()
       
       
       if( sth.count == 0 )
         
         sth.finish
       else
         sth.fetch do |row|
           element.uri = row[0]
           element.last_modified = row[1]
         end
         
         sth.finish
         
         sth = @dbh.prepare("delete data_hive.uri_queue WHERE uri = ?")
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
         @dbh.disconnect if @dbh
     end
     
     return element
   end
   
   def uninit()
     disconnect_db()
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
