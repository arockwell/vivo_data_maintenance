#!/usr/bin/ruby

require 'rubygems'
require 'vivo_web_api'
require 'pp'

require '~/.passwords.rb'

types = %w{person organization role position grant}

types.each do |type|
  uri_label = {}
  File.open("label_#{type}.txt").each do |line|
    (uri, label) = line.chomp.split("\t")
    if uri_label[uri].nil? 
      uri_label[uri] = {}
      uri_label[uri][:label] = []
    end
    uri_label[uri][:label] << label
  end
  uri_label = uri_label.reject do |key, value|
    if value[:label].size < 2
      true
    else
      false
    end
  end

  label_pred = RDF::URI.new("http://www.w3.org/2000/01/rdf-schema#label")
  RDF::Writer.open("duplicate_label_#{type}.nt") do |writer|
    uri_label.each do |uri, value|
      value[:label].each do |label|
        writer << RDF::Statement(RDF::URI.new(uri), label_pred, label)
      end
    end
  end
end
