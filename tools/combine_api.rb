#!/usr/bin/env ruby

require 'json'

STARTING_DIR="api"
OUTPUT_FILENAME = "all.json"

json_filenames = Dir.glob(File.join(STARTING_DIR, "*.json"))

all_data = []

json_filenames.each do |filename|
  rawdata = JSON.parse(File.open(filename, 'r').read)
  puts rawdata['count']
  puts rawdata['blocks'].length
  puts ""
  newdata = {"api" => rawdata['api'], 'count' => rawdata['count'], 'coocurance' => rawdata['coocurance']}
  all_data << newdata
end

all_data = all_data.sort_by {|hsh| hsh["count"]}.reverse

File.open(OUTPUT_FILENAME, 'w') do |file|
  file.puts JSON.pretty_generate(JSON.parse(all_data.to_json))
end

