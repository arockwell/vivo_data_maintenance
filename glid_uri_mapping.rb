#!/usr/bin/ruby -w

# Script to build the rewrite map file to match glid -> uri. 

require 'rubygems'
require 'vivo_web_api'
require 'conf.rb'

sparql = <<-EOH
PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX ufVivo: <http://vivo.ufl.edu/ontology/vivo-ufl/>

select distinct ?person ?gatorlink
where
{
  ?person rdf:type foaf:Person .
  ?person ufVivo:gatorlink ?gatorlink_with_type .
  let (?gatorlink := str(?gatorlink_with_type)) . 
}
EOH

client = VivoWebApi::Client.new(ENV['vivo_hostname'])
results = client.execute_sparql_select(ENV['vivo_username'], ENV['vivo_password'], sparql, 'RS_JSON')

output = ""
results.each do |result|
  uri = 'n' + result[:person].to_s.match('http://vivo.ufl.edu/individual/n(\d+)')[1]
  output = output + "#{result[:gatorlink].value} #{uri}\n"
end

File.open(ENV['mod_rewrite_map_file'], 'w') { |f| f.write(output) }
