module QueryObject

  def query(sparql)
    RDF::Graph.new << SPARQL::Client.new(DATA_ENDPOINT).query(sparql)
  end

end