#!/usr/bin/ruby

require 'rubygems'
require 'vivo_web_api'
require 'pp'

require '~/.passwords.rb'

uri_label = {}
File.open('labels.txt').each do |line|
  (uri, label) = line.split("\t")
  if uri_label[uri].nil?
    uri_label[uri] = []
  end
  uri_label[uri] << label
end

uri_label = uri_label.reject do |key, value|
  if value.size < 2
    true
  else
    false
  end
end

uri_label.each do |uri, labels|
  labels.each do |label|
    puts "#{uri}\t#{label}"
  end
end
