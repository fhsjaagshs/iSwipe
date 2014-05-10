#!/usr/bin/env ruby

require "sequel"
require "plist"
require "cfpropertylist"

DB = Sequel.connect("sqlite://dictionaries.db")

DB.run("CREATE TABLE dict_en (word varchar(255) NOT NULL PRIMARY KEY, match varchar(255) NOT NULL)")

DB.run("CREATE TABLE dict_en_tmp (word varchar(255) NOT NULL PRIMARY KEY, match varchar(255) NOT NULL)")

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