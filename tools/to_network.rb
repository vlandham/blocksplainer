#!/usr/bin/env ruby

require 'json'

INTPUT_FILENAME="all.json"
OUTPUT_FILENAME = "api_network.json"


data = JSON.parse(File.open(INTPUT_FILENAME, 'r').read)

nodes = {}
data.each do |api|
  nodes[api["api"]] = {"api" => api["api"], "count" => api["count"]}
end

links = []
data.each do |api|
  source = nodes[api["api"]]
  api["coocurance"].each do |key,value|
    target = nodes[key]
  end
end

