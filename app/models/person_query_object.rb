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
        ?person a schema:Person .
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:middleName ?middleName } .
        OPTIONAL { ?person parl:surname ?surname } .
        OPTIONAL { ?person parl:dateOfBirth ?dateOfBirth } .
        FILTER (?person = <#{DATA_URI_PREFIX}/#{id}> )
      }
    ")
  end

  def self.constituencies(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?sitting a parl:Sitting ;
                  parl:sittingStartDate ?sittingStartDate ;
        		      parl:sittingEndDate ?sittingEndDate ;
                  parl:sittingHasConstituency ?constituency .
    	  ?constituency a parl:Constituency ;
                      parl:constituencyName ?constituencyName ;
        		          parl:constituencyStartDate ?constituencyStartDate ;
        		          parl:constituencyEndDate ?constituencyEndDate .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasConstituency ?constituency .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
        OPTIONAL { ?constituency parl:constituencyStartDate ?constituencyStartDate . }
		    OPTIONAL { ?constituency parl:constituencyEndDate ?constituencyEndDate . }

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
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

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.parties(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?partyMembership a parl:PartyMembership ;
                           parl:partyMembershipStartDate ?partyMembershipStartDate ;
                           parl:partyMembershipEndDate ?partyMembershipEndDate ;
                           parl:partyMembershipHasParty ?party .
        ?party a parl:Party ;
                 parl:partyName ?partyName .
        }
        WHERE {
          ?member parl:personHasPartyMembership ?partyMembership .
          ?partyMembership parl:partyMembershipHasParty ?party .
            OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
            OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
            OPTIONAL { ?party parl:partyName ?partyName . }
            FILTER(?member=<http://id.ukpds.org/8045a1f9-b096-4bb3-8a52-f367a694dac2>)
      }
    ")
  end

end