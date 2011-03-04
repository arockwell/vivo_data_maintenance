#!/usr/bin/ruby

require 'rubygems'
require 'vivo_web_api'
require 'pp'

require 'conf.rb'

sparql = <<-EOH
PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX ufVivo: <http://vivo.ufl.edu/ontology/vivo-ufl/>
PREFIX core: <http://vivoweb.org/ontology/core#>

select ?org ?sponsorAwardId
where
{
    ?org rdf:type foaf:Organization .
    ?org ufVivo:harvestedBy "DSR-Harvester" .
    ?org core:sponsorAwardId ?sponsorAwardId 
}
order by ?org ?sponsorAwardId
EOH

exception_list = [
  "http://vivo.ufl.edu/individual/n547658293",
  "http://vivo.ufl.edu/individual/n721886660",
  "http://vivo.ufl.edu/individual/n395935430",
  "http://vivo.ufl.edu/individual/n1038849538",
  "http://vivo.ufl.edu/individual/n1132616728",
  "http://vivo.ufl.edu/individual/n1839441072",
  "http://vivo.ufl.edu/individual/n39911737",
  "http://vivo.ufl.edu/individual/n729638743",
  "http://vivo.ufl.edu/individual/n1396213239",
  "http://vivo.ufl.edu/individual/n850176725",
  "http://vivo.ufl.edu/individual/n1662420936",
  "http://vivo.ufl.edu/individual/n677797295",
  "http://vivo.ufl.edu/individual/n790858564",
  "http://vivo.ufl.edu/individual/n309570333",
  "http://vivo.ufl.edu/individual/n280975397",
  "http://vivo.ufl.edu/individual/n1382291231",
  "http://vivo.ufl.edu/individual/n1398229143",
  "http://vivo.ufl.edu/individual/n812436442",
  "http://vivo.ufl.edu/individual/n1994076783",
  "http://vivo.ufl.edu/individual/n1465078499",
  "http://vivo.ufl.edu/individual/n639473646",
  "http://vivo.ufl.edu/individual/n589574798",
  "http://vivo.ufl.edu/individual/n900600639",
  "http://vivo.ufl.edu/individual/n374907303",
  "http://vivo.ufl.edu/individual/n1255426023",
  "http://vivo.ufl.edu/individual/n1344046068",
  "http://vivo.ufl.edu/individual/n1479120978",
  "http://vivo.ufl.edu/individual/n293731431",
  "http://vivo.ufl.edu/individual/n1388275204",
  "http://vivo.ufl.edu/individual/n1967791030",
  "http://vivo.ufl.edu/individual/n324348159",
  "http://vivo.ufl.edu/individual/n1467068203",
  "http://vivo.ufl.edu/individual/n660650738",
  "http://vivo.ufl.edu/individual/n1902337036",
  "http://vivo.ufl.edu/individual/n257571360",
  "http://vivo.ufl.edu/individual/n1915680199",
  "http://vivo.ufl.edu/individual/n1909135946",
  "http://vivo.ufl.edu/individual/n1504258123",
  "http://vivo.ufl.edu/individual/n492644065",
  "http://vivo.ufl.edu/individual/n1181782086",
  "http://vivo.ufl.edu/individual/n1381117849",
  "http://vivo.ufl.edu/individual/n2009167027",
  "http://vivo.ufl.edu/individual/n1745399277",
  "http://vivo.ufl.edu/individual/n1643465115",
  "http://vivo.ufl.edu/individual/n1840047133",
  "http://vivo.ufl.edu/individual/n1533778995",
  "http://vivo.ufl.edu/individual/n603637889",
  "http://vivo.ufl.edu/individual/n216091366",
  "http://vivo.ufl.edu/individual/n2016582784",
  "http://vivo.ufl.edu/individual/n438591082",
  "http://vivo.ufl.edu/individual/n1423191828",
  "http://vivo.ufl.edu/individual/n79295740",
  "http://vivo.ufl.edu/individual/n1283595663",
  "http://vivo.ufl.edu/individual/n1145341850",
  "http://vivo.ufl.edu/individual/n1226353075",
  "http://vivo.ufl.edu/individual/n2123045971",
  "http://vivo.ufl.edu/individual/n1036431857",
  "http://vivo.ufl.edu/individual/n543575083",
  "http://vivo.ufl.edu/individual/n1767779533",
  "http://vivo.ufl.edu/individual/n1850270004",
  "http://vivo.ufl.edu/individual/n1057159675",
  "http://vivo.ufl.edu/individual/n403036577",
  "http://vivo.ufl.edu/individual/n2069716569",
  "http://vivo.ufl.edu/individual/n618548099",
  "http://vivo.ufl.edu/individual/n1998065287",
  "http://vivo.ufl.edu/individual/n1954008504",
  "http://vivo.ufl.edu/individual/n1494161670",
  "http://vivo.ufl.edu/individual/n328444532",
  "http://vivo.ufl.edu/individual/n757061210",
  "http://vivo.ufl.edu/individual/n1122249815",
  "http://vivo.ufl.edu/individual/n202496679",
  "http://vivo.ufl.edu/individual/n1505768652",
  "http://vivo.ufl.edu/individual/n1093358460",
  "http://vivo.ufl.edu/individual/n939659932",
  "http://vivo.ufl.edu/individual/n200569003",
  "http://vivo.ufl.edu/individual/n1651327872",
  "http://vivo.ufl.edu/individual/n863334736",
  "http://vivo.ufl.edu/individual/n1187205698",
  "http://vivo.ufl.edu/individual/n2145404322",
  "http://vivo.ufl.edu/individual/n1856416225",
  "http://vivo.ufl.edu/individual/n1091079152",
  "http://vivo.ufl.edu/individual/n1740999425",
  "http://vivo.ufl.edu/individual/n744564525",
  "http://vivo.ufl.edu/individual/n1311287213",
  "http://vivo.ufl.edu/individual/n1031153205",
  "http://vivo.ufl.edu/individual/n573042090",
  "http://vivo.ufl.edu/individual/n2079752409",
  "http://vivo.ufl.edu/individual/n1909593343",
  "http://vivo.ufl.edu/individual/n293523476",
  "http://vivo.ufl.edu/individual/n2100099556",
  "http://vivo.ufl.edu/individual/n907940907",
  "http://vivo.ufl.edu/individual/n1867104462",
  "http://vivo.ufl.edu/individual/n1116352629",
  "http://vivo.ufl.edu/individual/n2138700383",
  "http://vivo.ufl.edu/individual/n690820234",
  "http://vivo.ufl.edu/individual/n895604021",
  "http://vivo.ufl.edu/individual/n1240586241",
  "http://vivo.ufl.edu/individual/n43386644",
  "http://vivo.ufl.edu/individual/n1805187682",
  "http://vivo.ufl.edu/individual/n534795864",
  "http://vivo.ufl.edu/individual/n1932475157",
  "http://vivo.ufl.edu/individual/n552701972",
  "http://vivo.ufl.edu/individual/n53982550",
  "http://vivo.ufl.edu/individual/n26526924",
  "http://vivo.ufl.edu/individual/n968781473",
  "http://vivo.ufl.edu/individual/n517232954",
  "http://vivo.ufl.edu/individual/n1180781608",
  "http://vivo.ufl.edu/individual/n1652247090",
  "http://vivo.ufl.edu/individual/n1611275481",
  "http://vivo.ufl.edu/individual/n1591692574",
  "http://vivo.ufl.edu/individual/n107586168",
  "http://vivo.ufl.edu/individual/n1588670070",
  "http://vivo.ufl.edu/individual/n1184908956",
  "http://vivo.ufl.edu/individual/n376246172",
  "http://vivo.ufl.edu/individual/n392095853",
  "http://vivo.ufl.edu/individual/n662150447",
  "http://vivo.ufl.edu/individual/n964532659",
  "http://vivo.ufl.edu/individual/n681387055",
  "http://vivo.ufl.edu/individual/n764582261",
  "http://vivo.ufl.edu/individual/n258442004",
  "http://vivo.ufl.edu/individual/n2098291333",
  "http://vivo.ufl.edu/individual/n673465769",
  "http://vivo.ufl.edu/individual/n1412750349",
  "http://vivo.ufl.edu/individual/n2087773382",
  "http://vivo.ufl.edu/individual/n1021345123",
  "http://vivo.ufl.edu/individual/n557336254",
  "http://vivo.ufl.edu/individual/n694571379"
]

client = VivoWebApi::Client.new(ENV['vivo_hostname'])
results = client.execute_sparql_select(ENV['vivo_username'], ENV['vivo_password'], sparql, 'RS_JSON')

results.delete_if do |result|
  exception_list.include?(result[:org].to_s) ? true : false
end


sponsor_award_id_hash = {}
results.each do |result|
  sponsor_award_id = result[:sponsorAwardId].value
  org_uri = result[:org].to_s
  if sponsor_award_id_hash[sponsor_award_id].nil?
    sponsor_award_id_hash[sponsor_award_id] = []
  end
  sponsor_award_id_hash[sponsor_award_id] << org_uri
end

uris_rename_pairs = []
sponsor_award_id_hash.keys.each do |key|
  if sponsor_award_id_hash[key].size > 0
    rename_uris = sponsor_award_id_hash[key][1..sponsor_award_id_hash[key].size]
    rename_uris.each do |rename_uri|
      uris_rename_pairs << [sponsor_award_id_hash[key][0], rename_uri]
    end
  end
end

uris_rename_pairs.each do |pair|
  puts "#{pair[0]}, #{pair[1]}"
  if !exception_list.include?(pair[1])
    client.merge_individuals(ENV['vivo_username'], ENV['vivo_password]', pair[0], pair[1])
  end
end
