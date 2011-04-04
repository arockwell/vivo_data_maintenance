
#!/usr/bin/ruby

require 'rubygems'
require 'vivo_web_api'

require '~/.passwords.rb'

sparql = <<-EOH
PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>

select ?uri ?label
where
{
  ?uri rdfs:label ?label
}
order by ?uri ?label
EOH

hostname = ENV['vivo_hostname'] 
username = ENV['vivo_username']
password = ENV['vivo_password']
sparql_client = VivoWebApi::Client.new(hostname)
sparql_client.authenticate(username, password)
results = sparql_client.execute_sparql_select(username, password, sparql)

results.each do |result|
  puts "#{result[:uri]}\t#{result[:label]}"
end
