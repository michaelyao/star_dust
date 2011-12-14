#!/usr/bin/ruby
require 'pg'
$maxwidth=12
conn = PGconn.connect(*["", 5432, '', '', "mango_test", "myao", "db2"])

res  = conn.exec('select tablename, tableowner from pg_tables')

res.each do |row|
  row.each do |column|
    print column
    (20-column.length).times{print " "}
  end
  puts
end




###### DROP ANY EXISTING rocks TABLE ######
  begin
    res = conn.exec("SELECT id FROM rocks;")
  rescue  # rocks table doesn't exist -- this is legitimate
  else    # rocks table exists, so delete it
    puts 'DELETING rocks...'
    res = conn.exec("DROP TABLE rocks;")
  end

puts "Createing rocks table"

###### CREATE AND POPULATE rocks TABLE ######
begin
  res = conn.exec("CREATE TABLE rocks (id serial, rockname char(20));")
  res = conn.exec("INSERT INTO ROCKS (rockname) values ('Diamond');")
  res = conn.exec("INSERT INTO ROCKS (rockname) values ('Ruby');")
  res = conn.exec("INSERT INTO ROCKS (rockname) values ('Emerald');")
rescue PGError => e
  puts "Error creating and filling rocks table."
  puts "Error code: #{e.result.result_status}"
  puts "Error message: #{e.result.result_error_message}"
  conn.close() if conn
end

###### PRINT COLUMN NAMES AS BANNER ABOVE DATA ######
puts
begin
  res  = conn.exec('SELECT column_name FROM mango_test.information_schema.columns WHERE table_name=\'rocks\';')

rescue PGError => e
  puts "Error selecting column names."
  puts "Error code: #{e.result.result_status}"
  puts "Error message: #{e.result.result_error_message}"
  conn.close() if conn
ensure
end

res.each do |row|
   row.each do |column|
   puts column
   ($maxwidth-column.length).times{print " "}
  end

  
end
puts
puts

###### PRINT CONTENTS OF ROWS OF rocks TABLE ######
begin
  res  = conn.exec('SELECT * FROM rocks;')

rescue PGError => e
  puts "Error retrieving rocks rows."
  puts "Error code: #{e.result.result_status}"
  puts "Error message: #{e.result.result_error_message}"
ensure
  conn.close() if conn
end

res.each do |row|
  row.each do |column|
    print column
    ($maxwidth-column.length).times{print " "}
  end
  puts
end
puts


