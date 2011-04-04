#!/usr/bin/ruby

require 'rubygems'
require 'vivo_web_api'

require '~/.passwords.rb'

sparql = <<-EOH
PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX ufVivo: <http://vivo.ufl.edu/ontology/vivo-ufl/>

select ?person ?ufid
where
{
  ?person rdf:type foaf:Person .
  ?person ufVivo:ufid ?raw_ufid .
  let (?ufid := str(?raw_ufid)) .
}
EOH

hostname = ENV['vivo_hostname'] 
username = ENV['vivo_username']
password = ENV['vivo_password']
sparql_client = VivoWebApi::Client.new(hostname)
sparql_client.authenticate(username, password)
results = sparql_client.execute_sparql_select(username, password, sparql)

person_ufid = {}
ufid_person = {}
person_ufid_error = {}
ufid_person_error = {}
results.each do |result| 
  person = result[:person]
  ufid = result[:ufid].value
  if person_ufid[person].nil?
    person_ufid[person] = [ufid]
  elsif !person_ufid[person].member?(ufid)
    puts "ERROR: #{person}"
  end

  if ufid_person[ufid].nil?
    ufid_person[ufid] = [person]
  elsif !ufid_person[ufid].member?(person)
    puts "ERROR: #{ufid}"
  end
end
