class SittingQueryObject
  extend QueryObject

  def self.person(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?member parl:forename ?forename ;
              	  parl:surname ?surname .
      }
      WHERE {
          ?sitting parl:sittingHasPerson ?member .
          OPTIONAL { ?member parl:forename ?forename . }
          OPTIONAL { ?member parl:surname ?surname . }

          FILTER(?sitting = <#{DATA_URI_PREFIX}/#{id}>)
      }")
  end

  def self.house(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
        ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasHouse ?house .

        FILTER(?sitting = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.constituency(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?constituency parl:constituencyName ?name .
      }
      WHERE {
        ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasConstituency ?constituency .
        OPTIONAL { ?constituency parl:constituencyName ?name . }

        FILTER(?sitting = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end
end
