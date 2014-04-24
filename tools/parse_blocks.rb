#!/usr/bin/env ruby

require 'json'

STARTING_DIR="api"
OUTPUT_FILENAME = "data/blocks.tsv"

json_filenames = Dir.glob(File.join(STARTING_DIR, "*.json"))

all_data = []
all_blocks = Hash.new(0)
block_authors = Hash.new
json_filenames.each do |filename|
  rawdata = JSON.parse(File.open(filename, 'r').read)
  api = rawdata['api']
  rawdata['blocks'].each do |block_num, block|
    block_authors[block_num] = block['userId']
    all_blocks[block_num] += 1
  end

  # authors.each do |name, count|
  #   all_data << [api, name, count, rawdata['count']]
  # end

  #newdata = {"api" => rawdata['api'], 'count' => rawdata['count'], 'coocurance' => rawdata['coocurance']}
  # all_data << newdata
end

# all_data = all_data.sort_by {|hsh| hsh[]}.reverse

File.open(OUTPUT_FILENAME, 'w') do |file|
  file.puts ['block_id', 'author'].join("\t")
  all_blocks.each do |block_key, count|
    author = block_authors[block_key]
    file.puts [block_key, author].join("\t")
    # file.puts JSON.pretty_generate(JSON.parse(all_data.to_json))
  end
end

