module QueryObject

  def query(sparql_query)
    SPARQL::Client.new(DATA_ENDPOINT).response(sparql_query, { content_type: 'text/turtle' }).body
  end

end