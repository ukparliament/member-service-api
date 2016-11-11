class ConstituencyQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituency parl:constituencyEndDate ?endDate ;
          			parl:constituencyStartDate ?startDate ;
         				parl:constituencyName ?name ;
      }
      WHERE {
      	?constituency a parl:Constituency .
          OPTIONAL { ?constituency parl:constituencyEndDate ?endDate . }
          OPTIONAL { ?constituency parl:constituencyStartDate ?startDate . }
          OPTIONAL { ?constituency parl:constituencyName ?name . }
      }
    ')
  end

  def self.find(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituency parl:constituencyEndDate ?endDate ;
          			parl:constituencyStartDate ?startDate ;
         				parl:constituencyName ?name ;
          			parl:constituencyLatitude ?latitude ;
          			parl:constituencyLongitude ?longitude .
      }
      WHERE {
          OPTIONAL { ?constituency parl:constituencyEndDate ?endDate . }
          OPTIONAL { ?constituency parl:constituencyStartDate ?startDate . }
          OPTIONAL { ?constituency parl:constituencyName ?name . }
          OPTIONAL { ?constituency parl:constituencyLatitude ?latitude . }
          OPTIONAL { ?constituency parl:constituencyLongitude ?longitude . }

          FILTER(?constituency=<http://id.ukpds.org/#{id}>)
      }
    ")
  end
end