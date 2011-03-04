#!/usr/bin/ruby -w

require 'rubygems'
require 'vivo_web_api'
require 'pp'
require 'open-uri'
require 'nokogiri'
require 'rdf'
require 'rdf/ntriples'

require 'conf.rb'

def dump_pmids(server, output_file)
  sparql = <<-EOH
PREFIX bibo: <http://purl.org/ontology/bibo/>
PREFIX ufVivo: <http://vivo.ufl.edu/ontology/vivo-ufl/>

select ?pub ?pmid
where
{
  ?pub bibo:pmid ?pmid .
  ?pub ufVivo:harvestedBy "PubMed-Harvester" .
}
  EOH

  client = VivoWebApi::Client.new(server)
  results = client.execute_sparql_select(ENV['vivo_username'], ENV['vivo_password'], sparql, 'RS_JSON')

  output = ""
  results.each do |result|
    output = output + "#{result[:pub].to_s}\t#{result[:pmid]}\n"
  end

  File.open(output_file, 'w') { |f| f.write(output) }
end

def read_pmid_dump(filename)
  results = {}
  File.read(filename).each do |line|
    (pub_uri, pmid) = line.chomp.split("\t")
    results[pub_uri] = pmid
  end
  return results
end

def retrieve_pmid_article_type(pmid)
  @doc = Nokogiri::XML(open("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=" + pmid + "&retmode=xml").read)
  types = @doc.xpath("//PublicationType").collect(&:text)
end

def map_types(uri, pm_type)
  pubmed_to_vivo_map = {
    "Addresses" => [ RDF::URI.new("http://vivoweb.org/ontology/core#ConferencePaper") ],
    "Atlases"  => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Bibliography" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Biobibliography" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Biography" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Book Reviews" => [ RDF::URI.new("http://vivoweb.org/ontology/core#Review") ],
    "Case Reports" => [ RDF::URI.new("http://vivoweb.org/ontology/core#CaseStudy") ],
    "Charts" => [ RDF::URI.new("http://purl.org/ontology/bibo/Image") ],
    "Classical Article" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Clinical Conference" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Clinical Trial" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Clinical Trial, Phase I" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Clinical Trial, Phase II" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Clinical Trial, Phase III" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Clinical Trial, Phase IV" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Collected Correspondence" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Collected Works" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Comment" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Comparative Study" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Congresses" => [ RDF::URI.new("http://purl.org/ontology/bibo/Proceedings") ],
    "Consensus Development Conference" => [ RDF::URI.new("http://purl.org/ontology/bibo/Proceedings") ],
    "Consensus Development Conference, NIH" => [ RDF::URI.new("http://purl.org/ontology/bibo/Proceedings") ],
    "Controlled Clinical Trial" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Cookbooks" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Corrected and Republished Article" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Database" => [ RDF::URI.new("http://vivoweb.org/ontology/core#Database") ],
    "Diaries" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Dictionary" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Directory" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Documentaries and Factual Films" => [ RDF::URI.new("http://purl.org/ontology/bibo/Film") ],
    "Drawings" => [ RDF::URI.new("http://purl.org/ontology/bibo/Image") ],
    "Duplicate Publication" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Editorial" => [ RDF::URI.new("http://vivoweb.org/ontology/core#EditorialArticle") ],
    "Encyclopedias" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Essays" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Evaluation Studies" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Festschrift" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Fictional Works" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Formularies" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Guidebooks" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Guideline" => [ RDF::URI.new("http://purl.org/ontology/bibo/Standard") ],
    "Handbooks" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Historical Article" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Incunabula" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Indexes" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Instruction" => [ RDF::URI.new("http://purl.org/ontology/bibo/Audio Visual Document") ],
    "Interview" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book"), RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Introductory Journal Article" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Journal Article" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Legal Cases" => [ RDF::URI.new("http://purl.org/ontology/bibo/LegalCaseDocument") ],
    "Legislation" => [ RDF::URI.new("http://purl.org/ontology/bibo/Legislation") ],
    "Maps" => [ RDF::URI.new("http://purl.org/ontology/bibo/Map") ],
    "Meeting Abstracts" => [ RDF::URI.new("http://purl.org/ontology/bibo/Conference Proceedings") ],
    "Meta-Analysis" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Multicenter Study" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "News" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Newspaper Article" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Patents" => [ RDF::URI.new("http://purl.org/ontology/bibo/Patent") ],
    "Patient Education Handout" => [ RDF::URI.new("http://purl.org/ontology/bibo/Document") ],
    "Periodical Index" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Periodicals" => [ RDF::URI.new("http://purl.org/ontology/bibo/Periodical") ],
    "Pharmacopoeias" => [ RDF::URI.new("http://purl.org/ontology/bibo/ReferenceSource") ],
    "Pictorial Works" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Portraits" => [ RDF::URI.new("http://purl.org/ontology/bibo/Image") ],
    "Practice Guideline" => [ RDF::URI.new("http://purl.org/ontology/bibo/Standard") ],
    "Randomized Controlled Trial" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Review" => [ RDF::URI.new("http://vivoweb.org/ontology/core#Review"), RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Statistics" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book"), RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Study Characteristics" => [ RDF::URI.new("http://purl.org/ontology/bibo/Article") ],
    "Technical Report" => [ RDF::URI.new("http://purl.org/ontology/bibo/Report") ],
    "Textbooks" => [ RDF::URI.new("http://purl.org/ontology/bibo/Book") ],
    "Twin Study" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ],
    "Validation Studies" => [ RDF::URI.new("http://purl.org/ontology/bibo/AcademicArticle") ]
  }

  statements = []
  type_predicate = RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
  pub_uri = RDF::URI.new(uri)
  if !pubmed_to_vivo_map[pm_type].nil? 
    pubmed_to_vivo_map[pm_type].each do |type|
      statements << RDF::Statement(pub_uri, type_predicate, type)
    end
  end

  return statements
end

  server = ENV['vivo_hostname']
  output_file = 'pub_pmid.txt'
  dump_pmids(server, output_file)

  pub_pmid_hash = read_pmid_dump(output_file)

  types_output_file = 'types.txt'
  output = ""
  pub_pmid_hash.each do |uri, pmid|
    begin
      types = retrieve_pmid_article_type(pmid)
    rescue Timeout::Error
      # bad pmids generate a timeout
      puts "Timed out on #{pmid}"
      next
    rescue OpenURI::HttpERROR => e
      puts "Recieved 403, 404, or 500 on #{pmid}. #{e.message}"
      next
    end
    types.each do |type|
      output = output + "#{uri}\t#{type}\t#{pmid}\n"
    end
    sleep 0.5
  end

  File.open(types_output_file, 'w') { |f| f.write(output) }

types_output_file = 'types.txt'
output = ""
File.read(types_output_file).each do |line|
  (uri, type, pmid) = line.chomp.split("\t")
  
  statements = map_types(uri, type)
  output = output + RDF::Writer.for(:ntriples).buffer do |writer|
    statements.each do |statement|
      writer << statement
    end
  end
end
File.open('output.nt', 'w') { |f| f.write(output) }
