class PersonQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	a parl:Person ;
         	parl:personGivenName ?givenName ;
         	parl:personFamilyName ?familyName .
      }
      WHERE {
        ?person a parl:Person .
        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .
      }'
    )
  end

  def self.all_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	a parl:Person ;
         	parl:personGivenName ?givenName ;
         	parl:personFamilyName ?familyName .
      }
      WHERE {
        ?person a parl:Person .
        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .

    	  FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      PREFIX schema: <http://schema.org/>
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      CONSTRUCT {
          ?person
              a parl:Person ;
              parl:personDateOfBirth ?dateOfBirth ;
              parl:personGivenName ?givenName ;
              parl:personOtherName ?otherName ;
              parl:personFamilyName ?familyName ;
    		      parl:personHasGenderIdentiy ?genderIdentity .
    		?genderIdentity
        		a parl:GenderIdentity ;
        		parl:genderIdentityHasGender ?gender .
    		?gender
        		a parl:Gender ;
        		parl:genderName ?genderName .
     	  ?contactPoint
            a parl:ContactPoint ;
        	  parl:email ?email ;
        	  parl:phoneNumber ?phoneNumber ;
        	  parl:faxNumber ?faxNumber ;
    		    parl:contactPointHasPostalAddress ?postalAddress .
    	  ?postalAddress
        	  a parl:PostalAddress ;
        	  parl:addressLine1 ?addressLine1 ;
			      parl:addressLine2 ?addressLine2 ;
        	  parl:addressLine3 ?addressLine3 ;
        	  parl:addressLine4 ?addressLine4 ;
        	  parl:addressLine5 ?addressLine5 ;
        	  parl:postCode ?postCode .
    	  ?constituency
        	   a parl:ConstituencyGroup ;
             parl:constituencyGroupName ?constituencyName .
    	  ?seatIncumbency
          		a parl:SeatIncumbency ;
        	  	parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        	  	parl:seatIncumbencyStartDate ?seatIncumbencyStartDate ;
				      parl:seatIncumbencyHasHouseSeat ?seat .
        ?seat
            	a parl:HouseSeat ;
            	parl:houseSeatHasConstituencyGroup ?constituency ;
            	parl:houseSeatHasHouse ?house .
    		?party
        	  	a parl:Party ;
             	parl:partyName ?partyName .
    		?partyMembership
            	a parl:PartyMembership ;
        	  	parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	  	parl:partyMembershipEndDate ?partyMembershipEndDate ;
				      parl:partyMembershipHasParty ?party .
    		?house a parl:House ;
            	parl:houseName ?houseName .
      }
      WHERE {
        ?person a parl:Person .
        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personOtherName ?otherName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .
        OPTIONAL { ?person parl:personDateOfBirth ?dateOfBirth } .
        ?person parl:personHasGenderIdentity ?genderIdentity .
        ?genderIdentity parl:genderIdentityHasGender ?gender .
        OPTIONAL { ?gender parl:genderName ?genderName . }

    	  OPTIONAL {
    	      ?person parl:memberHasSeatIncumbency ?seatIncumbency .
    	  	  ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?seat .
    	  	  ?seat parl:houseSeatHasConstituencyGroup ?constituency .
    	      ?seat parl:houseSeatHasHouse ?house .
    	      OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
    	      ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
    	      ?constituency parl:constituencyGroupName ?constituencyName .
    	      ?house parl:houseName ?houseName .
    	  }

        OPTIONAL {
    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
          ?partyMembership parl:partyMembershipHasParty ?party .
          ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
          OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
          ?party parl:partyName ?partyName .
        }

    	  OPTIONAL { ?person parl:personHasContactPoint ?contactPoint .
        	OPTIONAL { ?contactPoint parl:phoneNumber ?phoneNumber . }
        	OPTIONAL { ?contactPoint parl:email ?email . }
        	OPTIONAL { ?contactPoint parl:faxNumber ?faxNumber . }

        	OPTIONAL {
        	    ?contactPoint parl:contactPointHasPostalAddress ?postalAddress .
				      OPTIONAL { ?postalAddress parl:addressLine1 ?addressLine1 . }
				      OPTIONAL { ?postalAddress parl:addressLine2 ?addressLine2 . }
        		  OPTIONAL { ?postalAddress parl:addressLine3 ?addressLine3 . }
        		  OPTIONAL { ?postalAddress parl:addressLine4 ?addressLine4 . }
        		  OPTIONAL { ?postalAddress parl:addressLine5 ?addressLine5 . }
        		  OPTIONAL { ?postalAddress parl:postCode ?postCode . }
        	}
    	  }

        FILTER(?person=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.constituencies(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?member a parl:Person ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	 ?constituency
        	  a parl:Constituency ;
            parl:constituencyName ?constituencyName ;
        	  parl:constituencyStartDate ?constituencyStartDate ;
        	  parl:constituencyEndDate ?constituencyEndDate .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingEndDate ?sittingEndDate ;
        	  parl:sittingStartDate ?sittingStartDate ;
       		  parl:connect ?constituency ;
            parl:relationship \"through\" .
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
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.current_constituency(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	 ?member a parl:Person ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	 ?constituency
        	  a parl:Constituency ;
            parl:constituencyName ?constituencyName ;
        	  parl:constituencyStartDate ?constituencyStartDate .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingStartDate ?sittingStartDate ;
       		  parl:connect ?constituency ;
            parl:relationship \"through\" .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  MINUS { ?sitting a parl:PastSitting . }
    	  ?seat parl:seatHasConstituency ?constituency .
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
        OPTIONAL { ?constituency parl:constituencyStartDate ?constituencyStartDate . }
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	?member a parl:Person ;
              parl:forename ?forename ;
              parl:surname ?surname .
      ?party
        	  a parl:Party ;
             parl:partyName ?partyName .
    	?partyMembership
            a parl:PartyMembership ;
        	  parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	  parl:partyMembershipEndDate ?partyMembershipEndDate ;
       		  parl:connect ?party ;
            parl:relationship \"through\" .
       }
       WHERE {
         ?member parl:personHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
         OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
         OPTIONAL { ?party parl:partyName ?partyName . }
    	   OPTIONAL { ?member parl:forename ?forename } .
         OPTIONAL { ?member parl:surname ?surname } .
         FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
       }
     ")
  end

  def self.current_party(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?member a parl:Person ;
              parl:forename ?forename ;
              parl:surname ?surname .
        ?party
        	  a parl:Party ;
             parl:partyName ?partyName .
    	  ?partyMembership
            a parl:PartyMembership ;
        	  parl:partyMembershipStartDate ?partyMembershipStartDate ;
       		  parl:connect ?party ;
            parl:relationship \"through\" .
        }
        WHERE {
          ?member parl:personHasPartyMembership ?partyMembership .
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    		  FILTER NOT EXISTS { ?partyMembership a parl:PastThing . }
        	OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
        	OPTIONAL { ?party parl:partyName ?partyName . }
    	    OPTIONAL { ?member parl:forename ?forename } .
          OPTIONAL { ?member parl:surname ?surname } .
          FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.contact_points(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
          a parl:Person ;
          parl:forename ?forename ;
          parl:surname ?surname .
        ?contactPoint
          a parl:ContactPoint ;
          parl:email ?email ;
          parl:telephone ?telephone ;
          parl:faxNumber ?faxNumber ;
          parl:streetAddress ?streetAddress ;
          parl:addressLocality ?addressLocality ;
          parl:postalCode ?postalCode .
      }
      WHERE {
	      ?person parl:personHasSitting ?sitting .
        ?sitting parl:sittingHasContactPoint ?contactPoint .
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:surname ?surname } .
        OPTIONAL{ ?contactPoint parl:email ?email . }
        OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
        OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
        OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
        OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
        OPTIONAL{ ?contactPoint parl:postalCode ?postalCode . }

        FILTER(?person=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.houses(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?member a parl:Person ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	  ?house a parl:House .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingEndDate ?sittingEndDate ;
        	  parl:sittingStartDate ?sittingStartDate ;
        	  parl:connect ?house ;
            parl:relationship \"through\" .
      }
      WHERE {
    	  ?member parl:personHasSitting ?sitting .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasHouse ?house .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .

        FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.current_house(id)
    self.uri_builder("
          PREFIX parl: <http://id.ukpds.org/schema/>
          CONSTRUCT{
            ?member a parl:Person ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	      ?house a parl:House .
    	      ?sitting
              a parl:Sitting ;
        	    parl:sittingStartDate ?sittingStartDate ;
        	    parl:connect ?house ;
              parl:relationship \"through\" .
          }
          WHERE {
            ?sitting a parl:Sitting .
            FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
            ?sitting parl:sittingHasPerson ?member .
            ?sitting parl:sittingHasSeat ?seat ;
                      parl:sittingStartDate ?sittingStartDate .
            ?seat parl:seatHasHouse ?house .
            OPTIONAL { ?member parl:forename ?forename } .
            OPTIONAL { ?member parl:surname ?surname } .

            FILTER(?member=<#{DATA_URI_PREFIX}/#{id}>)
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