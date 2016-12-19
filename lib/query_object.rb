module QueryObject

  def uri_builder(sparql_query)
    URI("#{DATA_ENDPOINT}?query=#{URI.escape(sparql_query)}")
  end

end