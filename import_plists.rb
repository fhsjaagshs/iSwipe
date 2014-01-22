#!/usr/bin/env ruby

require "sequel"
require "plist"
require "cfpropertylist"

DB = Sequel.connect("sqlite://dictionaries.db")

DB.run("CREATE TABLE dict_en (id integer NOT NULL PRIMARY KEY AUTOINCREMENT, word varchar(255), match varchar(255))")

DB.run("CREATE TABLE dict_en_tmp (id integer NOT NULL PRIMARY KEY AUTOINCREMENT, word varchar(255), match varchar(255))")

=begin
DB.create_table :dict_en do
  primary_key :id
  String :word
  String :match
end

DB.create_table :dict_en_tmp do
  primary_key :id
  String :word
  String :match
end
=end

dict_en_tmp = DB[:dict_en_tmp]

## Don't get xxLIM.plist or x.plist dictionary files, they appear to mess stuff up.
## Or at least give them less priority...

dirs = Dir.entries("Dictionaries/EN/").select { |filename| filename.split(".")[-1] == "plist" && filename.length == 8 }

dirs.each do |filename|
  puts filename
  plist = CFPropertyList::List.new(:file => "Dictionaries/EN/"+filename)
  data = CFPropertyList.native_types(plist.value)

  data.each do |hash|
    dict_en_tmp.insert(:word => hash["Word"], :match => hash["Match"])
  end
end

DB.run("INSERT into dict_en SELECT * from dict_en_tmp group by match,word")
DB.run("DROP TABLE dict_en_tmp")
DB.run("VACUUM") # Rebuilds the now (heavily) fragmented DB. I think it's unique to SQLite.
