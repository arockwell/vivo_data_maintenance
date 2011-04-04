
#!/usr/bin/ruby

require 'rubygems'
require 'vivo_web_api'

require '~/.passwords.rb'

# type is a RDF::URI
def find_labels_by_type(type)

  sparql = <<-EOH
PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

select ?uri ?label 
where
{
  ?uri rdfs:label ?label .
  ?uri rdf:type <#{type}>
}
order by ?uri ?label
  EOH

  hostname = ENV['vivo_hostname'] 
  username = ENV['vivo_username']
  password = ENV['vivo_password']
  sparql_client = VivoWebApi::Client.new(hostname)
  sparql_client.authenticate(username, password)
  sparql_client.execute_sparql_select(username, password, sparql)
end

def write_results_to_file(results, type)
  File.open("label_#{type}.txt", "w") do |f|
    results.each do |result|
      f.write("#{result[:uri]}\t#{result[:label]}\n")
    end
  end
end


types = [ 
  {:uri => RDF::URI.new('http://xmlns.com/foaf/0.1/Person'), :name => "person"},
  {:uri => RDF::URI.new('http://xmlns.com/foaf/0.1/Organization'), :name => "organization"},
  {:uri => RDF::URI.new('http://vivoweb.org/ontology/core#Grant'), :name => "grant"},
  {:uri => RDF::URI.new('http://vivoweb.org/ontology/core#Position'), :name => "position"},
  {:uri => RDF::URI.new('http://vivoweb.org/ontology/core#Role'), :name => "role"}
]

types.each do |type|
  results = find_labels_by_type(type[:uri])
  write_results_to_file(results, type[:name])
end
