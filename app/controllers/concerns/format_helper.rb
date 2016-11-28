module FormatHelper
  def format(data)
    respond_to do |format|
      format.ttl { render :plain => convert_to_ttl(data)}
      format.nt { render :plain => convert_to_ttl(data)}
    end
  end

  def convert_to_ttl(data)
    result = ""
    data.each_statement do |statement|
      result << RDF::NTriples::Writer.serialize(statement)
    end
    result
  end
end