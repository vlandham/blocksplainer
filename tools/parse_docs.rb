#!/usr/bin/env ruby

DOC_FILE = "data/d3_doc.txt"

lines = File.open(DOC_FILE,'r').read.split("\n")
output_filename = "data/docs.tsv"

docs = []
current_main = nil
current_sub = nil

file = File.open(output_filename, 'w')
file.puts ["command", "main", "sub"].join("\t")
lines.each do |line|
  if line =~ /^###.*\[(.*)\]/
    current_sub = $1
  elsif line =~ /^##.*\[(.*)\]/
    current_main = $1
  elsif line =~ /^\*.*\[(.*)\]/
    command = $1.split("|")[0]
    file.puts [command, current_main, current_sub].join("\t")
  else
    puts "huh?: #{line}"
  end
end
