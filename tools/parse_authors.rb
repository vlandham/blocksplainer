#!/usr/bin/env ruby

require 'json'

STARTING_DIR="api"
OUTPUT_FILENAME = "data/authors.tsv"

json_filenames = Dir.glob(File.join(STARTING_DIR, "*.json"))

all_data = []

json_filenames.each do |filename|
  rawdata = JSON.parse(File.open(filename, 'r').read)
  authors = Hash.new(0)
  api = rawdata['api']
  rawdata['blocks'].each do |block_num, block|
    authors[block['userId']] += 1
  end

  authors.each do |name, count|
    all_data << [api, name, count]
  end

  #newdata = {"api" => rawdata['api'], 'count' => rawdata['count'], 'coocurance' => rawdata['coocurance']}
  # all_data << newdata
end

# all_data = all_data.sort_by {|hsh| hsh[]}.reverse

File.open(OUTPUT_FILENAME, 'w') do |file|
  all_data.each do |d|
    file.puts d.join("\t")
    # file.puts JSON.pretty_generate(JSON.parse(all_data.to_json))
  end
end

