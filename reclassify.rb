#!/usr/bin/ruby

require 'rubygems'
require 'rdf/raptor'
require 'rdf/ntriples'

data_remove = []
data_add = []

type_pred = RDF::URI.new('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
faculty_member_pred = RDF::URI.new('http://vivoweb.org/ontology/core#FacultyMember')
courtesy_faculty_pred = RDF::URI.new('http://vivo.ufl.edu/ontology/vivo-ufl/CourtesyFaculty')

File.open("courtesy_remove_uri.txt").each do |line|
  uri = line.chomp
  data_remove << RDF::Statement.new(RDF::URI.new(uri), type_pred, faculty_member_pred)
  data_add << RDF::Statement.new(RDF::URI.new(uri), type_pred, courtesy_faculty_pred)
end

RDF::Writer.open('remove_faculty_class.nt') do |writer|
  data_remove.each do |datum|
    writer << datum
  end
end

RDF::Writer.open('add_faculty_class.nt') do |writer|
  data_add.each do |datum|
    writer << datum
  end
end
