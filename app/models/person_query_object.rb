class PersonQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
          parl:forename ?forename ;
          parl:surname ?surname .
      }
      WHERE {
        ?person a parl:Person .
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:surname ?surname } .
      }'
    )
  end

  def self.all_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
          parl:forename ?forename ;
          parl:surname ?surname ;
      }
      WHERE {
        ?person a parl:Person .
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:surname ?surname } .

    	  FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      PREFIX schema: <http://schema.org/>
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      CONSTRUCT {
          <#{DATA_URI_PREFIX}/#{id}>
              parl:dateOfBirth ?dateOfBirth ;
              parl:forename ?forename ;
              parl:middleName ?middleName ;
              parl:surname ?surname ;
              parl:gender ?gender .
     	  ?contactPoint
        	  parl:email ?email ;
        	  parl:telephone ?telephone ;
        	  parl:faxNumber ?faxNumber ;
        	  parl:streetAddress ?streetAddress ;
        	  parl:addressLocality ?addressLocality ;
        	  parl:postalCode ?postalCode .
    	  ?constituency
        	  a parl:Constituency ;
              parl:constituencyName ?constituencyName ;
        	  parl:constituencyStartDate ?constituencyStartDate ;
        	  parl:constituencyEndDate ?constituencyEndDate .
    	  _:a
        	  parl:sittingEndDate ?sittingEndDate ;
        	  parl:sittingStartDate ?sittingStartDate ;
       		  parl:connect ?constituency ;
        	  parl:connect ?house ;
          	  parl:objectId ?sitting .
    	?party
        	  a parl:Party ;
              parl:partyName ?partyName .
    	_:b
        	  parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	  parl:partyMembershipEndDate ?partyMembershipEndDate ;
       		  parl:connect ?party ;
          	  parl:objectId ?partyMembership .
    	?house a parl:House .
      }
      WHERE {
        <#{DATA_URI_PREFIX}/#{id}> a parl:Person .
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:middleName ?middleName } .
        OPTIONAL { ?person parl:surname ?surname } .
        OPTIONAL { ?person parl:dateOfBirth ?dateOfBirth } .
        ?gender rdfs:subClassOf parl:HasGender .
        <#{DATA_URI_PREFIX}/#{id}> a ?gender .
        FILTER NOT EXISTS { ?gender rdfs:seeAlso schema:GenderType } .

    	<#{DATA_URI_PREFIX}/#{id}> parl:personHasSitting ?sitting .
    	?sitting parl:sittingHasSeat ?seat .
    	?seat parl:seatHasConstituency ?constituency .
        ?seat parl:seatHasHouse ?house .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
        OPTIONAL { ?constituency parl:constituencyStartDate ?constituencyStartDate . }
		OPTIONAL { ?constituency parl:constituencyEndDate ?constituencyEndDate . }

    	<#{DATA_URI_PREFIX}/#{id}> parl:personHasPartyMembership ?partyMembership .
        ?partyMembership parl:partyMembershipHasParty ?party .
        OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
        OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
        OPTIONAL { ?party parl:partyName ?partyName . }

    	OPTIONAL {
        	?sitting parl:sittingHasContactPoint ?contactPoint .
        	OPTIONAL{ ?contactPoint parl:email ?email . }
        	OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
        	OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
        	OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
        	OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
        	OPTIONAL{ ?contactPoint parl:postalCode ?postalCode . }
    	}
      }")
  end

  # def self.find(id)
  #   self.uri_builder("
  #     PREFIX parl: <http://id.ukpds.org/schema/>
  #     PREFIX schema: <http://schema.org/>
  #     PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
  #     CONSTRUCT {
  #         ?person
  #             parl:dateOfBirth ?dateOfBirth ;
  #             parl:forename ?forename ;
  #             parl:middleName ?middleName ;
  #             parl:surname ?surname ;
  #             parl:gender ?gender .
  #     }
  #     WHERE {
  #       ?person a parl:Person .
  #       OPTIONAL { ?person parl:forename ?forename } .
  #       OPTIONAL { ?person parl:middleName ?middleName } .
  #       OPTIONAL { ?person parl:surname ?surname } .
  #       OPTIONAL { ?person parl:dateOfBirth ?dateOfBirth } .
  #         ?gender rdfs:subClassOf parl:HasGender .
  #         ?person a ?gender .
  #         FILTER NOT EXISTS { ?gender rdfs:seeAlso schema:GenderType } .
  #       FILTER (?person = <#{DATA_URI_PREFIX}/#{id}> )
  #     }
  #   ")
  # end

  def self.constituencies(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	 ?constituency a parl:Constituency ;
                       parl:constituencyName ?constituencyName ;
        		           parl:constituencyStartDate ?constituencyStartDate ;
        		           parl:constituencyEndDate ?constituencyEndDate .
    	_:x
        	parl:sittingEndDate ?sittingEndDate ;
        	parl:sittingStartDate ?sittingStartDate ;
       		parl:connect ?constituency ;
          parl:objectId ?sitting .
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

  def self.current_constituency(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	 ?constituency a parl:Constituency ;
                       parl:constituencyName ?constituencyName ;
        		           parl:constituencyStartDate ?constituencyStartDate .
    	_:x
        	parl:sittingStartDate ?sittingStartDate ;
       		parl:connect ?constituency ;
          parl:objectId ?sitting .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  MINUS { ?sitting a parl:PastSitting . }
    	  ?seat parl:seatHasConstituency ?constituency .
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
        OPTIONAL { ?constituency parl:constituencyStartDate ?constituencyStartDate . }

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?party a parl:Party ;
                 parl:partyName ?partyName .
    	  _:x
        	parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	parl:partyMembershipEndDate ?partyMembershipEndDate ;
       		parl:connect ?party ;
          parl:objectId ?partyMembership .
       }
       WHERE {
         ?member parl:personHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
         OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
         OPTIONAL { ?party parl:partyName ?partyName . }
         FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
       }
     ")
  end

  def self.current_party(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?party a parl:Party ;
                 parl:partyName ?partyName .
    	_:x
        	parl:partyMembershipStartDate ?partyMembershipStartDate ;
       		parl:connect ?party ;
          parl:objectId ?partyMembership .
        }
        WHERE {
          ?member parl:personHasPartyMembership ?partyMembership .
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    		FILTER NOT EXISTS { ?partyMembership a parl:PastThing . }
        	OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
        	OPTIONAL { ?party parl:partyName ?partyName . }
          FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.contact_points(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?contactPoint parl:email ?email ;
        			parl:telephone ?telephone ;
        			parl:faxNumber ?faxNumber ;
        			parl:streetAddress ?streetAddress ;
        			parl:addressLocality ?addressLocality ;
        			parl:postalCode ?postalCode .
      }
      WHERE {
	      ?member parl:personHasSitting ?sitting .
        ?sitting parl:sittingHasContactPoint ?contactPoint .
        OPTIONAL{ ?contactPoint parl:email ?email . }
        OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
        OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
        OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
        OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
        OPTIONAL{ ?contactPoint parl:postalCode ?postalCode . }

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.houses(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	 ?house a parl:House .
    	_:x
        	parl:sittingEndDate ?sittingEndDate ;
        	parl:sittingStartDate ?sittingStartDate ;
       		parl:connect ?house ;
          parl:objectId ?sitting .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasHouse ?house .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }


        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.current_house(id)
    self.uri_builder("
          PREFIX parl: <http://id.ukpds.org/schema/>
          CONSTRUCT{
          ?house a parl:House .
          _:x
            parl:sittingStartDate ?sittingStartDate ;
            parl:connect ?house ;
            parl:objectId ?sitting .
          }
          WHERE {
            ?sitting a parl:Sitting .
          FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
            ?sitting parl:sittingHasPerson <#{DATA_URI_PREFIX}/#{id}> .
          ?sitting parl:sittingHasSeat ?seat ;
              parl:sittingStartDate ?sittingStartDate .
          ?seat parl:seatHasHouse ?house .
          }
        ")
  end

  def self.sittings(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?sitting parl:sittingStartDate ?sittingStartDate ;
        			parl:sittingEndDate ?sittingEndDate .
      }
      WHERE {
      	?member parl:personHasSitting ?sitting .
        OPTIONAL { ?sitting parl:sittingStartDate ?sittingStartDate . }
        OPTIONAL { ?sitting parl:sittingEndDate ?sittingEndDate . }

        FILTER(?member = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end
end