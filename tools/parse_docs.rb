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
    current_sub = $1.gsub("]","").split("|")[0].split("(")[0].strip
    if line =~ /\]\((.*)\)$/
      current_sub = $1
    end
  elsif line =~ /^##.*\[(.*)\]/
    current_main = $1
    command = nil
    if current_main =~ /^d3/
      command = current_main.split("(")[0].strip
    end
    current_main = current_main.gsub("]","").split("|")[0].split("(")[0].strip
    if line =~ /\]\((.*)\)$/
      current_main = $1
    end
    if command
      file.puts [command, current_main, 'base'].join("\t")
    end
  elsif line =~ /^\*.*\[(.*)\]/
    command = $1.split("|")[0]
    file.puts [command, current_main, current_sub].join("\t")
  else
    puts "huh?: #{line}"
  end
end
