class PersonQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>
      PREFIX schema: <http://schema.org/>
      CONSTRUCT {
        ?person
          parl:forename ?forename ;
          parl:middleName ?middleName ;
          parl:surname ?surname ;
      }
      WHERE {
        ?person
          a schema:Person .
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:middleName ?middleName } .
        OPTIONAL { ?person parl:surname ?surname } .
      }'
    )
  end

  def self.find(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      PREFIX schema: <http://schema.org/>
      CONSTRUCT {
          ?person
              parl:dateOfBirth ?dateOfBirth ;
              parl:forename ?forename ;
              parl:middleName ?middleName ;
              parl:surname ?surname .
      }
      WHERE {
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:middleName ?middleName } .
        OPTIONAL { ?person parl:surname ?surname } .
        OPTIONAL { ?person parl:dateOfBirth ?dateOfBirth } .
        FILTER (?person = <http://id.ukpds.org/#{id}> )
      }
    ")
  end

  def self.constituencies(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?sitting parl:sittingStartDate ?sittingStartDate ;
        		      parl:sittingEndDate ?sittingEndDate ;
      	          parl:sittingHasSeat ?seat .
    	  ?constituency parl:constituencyName ?constituencyName ;
        		          parl:constituencyStartDate ?constituencyStartDate ;
        		          parl:constituencyEndDate ?constituencyEndDate ;
    				          parl:constituencyHasSeat ?seat .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasConstituency ?constituency .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?constituency parl:constituencyName ?name . }
        OPTIONAL { ?constituency parl:constituencyStartDate ?constituencyStartDate . }
		    OPTIONAL { ?constituency parl:constituencyEndDate ?constituencyEndDate . }

        FILTER(?member=<http://id.ukpds.org/#{id}>)
      }
    ")
  end

  def self.current_constituencies(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?sitting parl:sittingStartDate ?sittingStartDate ;
        		      parl:sittingEndDate ?sittingEndDate ;
      	          parl:sittingHasSeat ?seat .
    	  ?constituency parl:constituencyName ?constituencyName ;
        		          parl:constituencyStartDate ?constituencyStartDate ;
        		          parl:constituencyEndDate ?constituencyEndDate ;
    				          parl:constituencyHasSeat ?seat .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  MINUS { ?sitting a parl:PastSitting . }
    	  ?seat parl:seatHasConstituency ?constituency .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?constituency parl:constituencyName ?name . }
        OPTIONAL { ?constituency parl:constituencyStartDate ?constituencyStartDate . }
		    OPTIONAL { ?constituency parl:constituencyEndDate ?constituencyEndDate . }

        FILTER(?member=<http://id.ukpds.org/#{id}>)
      }
    ")
  end

end