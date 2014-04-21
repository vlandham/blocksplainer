#!/usr/bin/env ruby

require 'json'

INTPUT_FILENAME="all.json"
OUTPUT_FILENAME = "api.tsv"


data = JSON.parse(File.open(INTPUT_FILENAME, 'r').read)
File.open(OUTPUT_FILENAME, 'w') do |file|
  file.puts(["source", "target", "count", "all"].join("\t"))
  data.each do |api|
    api["coocurance"].each do |key,value|
      file.puts([api["api"], key, value, api["count"]].join("\t")) if api['api'] != key
    end
  end
end
