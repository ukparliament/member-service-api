QUERY_BY_BIRTHDATE_STATEMENTS = [
    RDF::Statement.new(RDF::URI.new('http://id.ukpds.org/00c50187-a32d-43b3-b0b5-5f68a03a2b68'), RDF::URI.new('http://id.ukpds.org/schema/forename'), "Michael"),
    RDF::Statement.new(RDF::URI.new('http://id.ukpds.org/00c50187-a32d-43b3-b0b5-5f68a03a2b68'), RDF::URI.new('http://id.ukpds.org/schema/middleName'), "Edward"),
    RDF::Statement.new(RDF::URI.new('http://id.ukpds.org/00c50187-a32d-43b3-b0b5-5f68a03a2b68'), RDF::URI.new('http://id.ukpds.org/schema/surname'), "Joicey")
]

QUERY_BY_BIRTHDATE_GRAPH = RDF::Graph.new
QUERY_BY_BIRTHDATE_STATEMENTS.each do |statement|
  QUERY_BY_BIRTHDATE_GRAPH << statement
end

