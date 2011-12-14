
   # simple.rb - simple MySQL script using Ruby DBI module

   require "dbi"

  def connect_to_mysql()
    puts "\nConnecting to MySQL..."
    #return DBI.connect("dbi:Mysql:test:localhost", "testuser", "testpass")
  
    return DBI.connect('DBI:Mysql:test', 'myid', '')
  end
  
  def connect_to_postgres()
    puts "\nConnecting to Postgres..."
puts "connect to db #{$:}"
    return DBI.connect("dbi:Pg:dbname=mango_test;host=localhost", "myao", "db2")
  end
  
  def exercise_database(dbh)
    
     row = dbh.select_one("SELECT VERSION()")
     puts "Server version: " + row[0]
     
     query = dbh.prepare("SELECT * FROM data_hive.uri_queue")
     query.execute()
  
    while row = query.fetch() do
      puts row
    end
   rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code: #{e.err}"
     puts "Error message: #{e.errstr}"
  end
  
  def main()
   # dbh = connect_to_mysql()
   # exercise_database(dbh)
   # dbh.disconnect
  
    dbh = connect_to_postgres()
    exercise_database(dbh)
    dbh.disconnect if dbh
  end

main()

   
