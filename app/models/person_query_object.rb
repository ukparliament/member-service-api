class PersonQueryObject
  extend QueryObject

  def self.all
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
      }")
  end

  def self.lookup(source, id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	a parl:Person .
      }
      WHERE {
        BIND(\"#{id}\" AS ?id)
        BIND(parl:#{source} AS ?source)

        ?person a parl:Person .
        ?person ?source ?id .
      }")
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

    	  FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
      }
    ")
  end

  def self.a_z_letters
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
	        ?s a parl:Person .
          ?s parl:personFamilyName ?familyName .

          BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }
    ')
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
              parl:personOtherNames ?otherName ;
              parl:personFamilyName ?familyName ;
    		      parl:personHasGenderIdentity ?genderIdentity ;
              parl:partyMemberHasPartyMembership ?partyMembership .
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
        	  	parl:incumbencyEndDate ?incumbencyEndDate ;
        	  	parl:incumbencyStartDate ?incumbencyStartDate ;
				      parl:seatIncumbencyHasHouseSeat ?seat ;
        		  parl:incumbencyHasContactPoint ?contactPoint .
    	  ?houseIncumbency
        		a parl:HouseIncumbency ;
        		parl:incumbencyEndDate ?incumbencyEndDate ;
        	  parl:incumbencyStartDate ?incumbencyStartDate ;
        		parl:houseIncumbencyHasHouse ?house ;
        		parl:incumbencyHasContactPoint ?contactPoint .
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
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personOtherNames ?otherName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .
        OPTIONAL { ?person parl:personDateOfBirth ?dateOfBirth } .
        ?person parl:personHasGenderIdentity ?genderIdentity .
        ?genderIdentity parl:genderIdentityHasGender ?gender .
        OPTIONAL { ?gender parl:genderName ?genderName . }

    	  OPTIONAL {
    	      ?person parl:memberHasIncumbency ?incumbency .
            OPTIONAL { ?incumbency parl:incumbencyEndDate ?incumbencyEndDate . }
    	      ?incumbency parl:incumbencyStartDate ?incumbencyStartDate .

        	  {
        	      ?incumbency a parl:HouseIncumbency .
                  BIND(?incumbency AS ?houseIncumbency)
                  ?houseIncumbency parl:houseIncumbencyHasHouse ?house .
            	  ?house parl:houseName ?houseName .
        	  }

        	  UNION {
        	      ?incumbency a parl:SeatIncumbency .
                BIND(?incumbency AS ?seatIncumbency)
                ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?seat .
            	  ?seat parl:houseSeatHasConstituencyGroup ?constituency .
    	      	  ?seat parl:houseSeatHasHouse ?house .
            	  ?house parl:houseName ?houseName .
            	  ?constituency parl:constituencyGroupName ?constituencyName .
        	  }

            OPTIONAL {
        	    ?incumbency parl:incumbencyHasContactPoint ?contactPoint .
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
    	    }

          OPTIONAL {
    	      ?person parl:partyMemberHasPartyMembership ?partyMembership .
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
            OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
            ?party parl:partyName ?partyName .
          }
        }
    ")
  end

  def self.constituencies(id)
    self.uri_builder("
       PREFIX parl: <http://id.ukpds.org/schema/>

       CONSTRUCT {
        ?person a parl:Person ;
              parl:personGivenName ?givenName ;
              parl:personFamilyName ?familyName .
    	 ?constituency
        	  a parl:ConstituencyGroup ;
            parl:constituencyGroupName ?constituencyName ;
        	  parl:constituencyGroupStartDate ?constituencyStartDate ;
        	  parl:constituencyGroupEndDate ?constituencyEndDate ;
            parl:constituencyGroupHasHouseSeat ?seat .
    	  ?seat
        	  a parl:HouseSeat ;
        	  parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:incumbencyEndDate ?seatIncumbencyEndDate ;
        	  parl:incumbencyStartDate ?seatIncumbencyStartDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .

        OPTIONAL {
    	    ?person parl:memberHasIncumbency ?seatIncumbency .
        	?seatIncumbency a parl:SeatIncumbency .
    	    ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?seat .
    	    ?seat parl:houseSeatHasConstituencyGroup ?constituency .
          OPTIONAL { ?seatIncumbency parl:incumbencyEndDate ?seatIncumbencyEndDate . }
          ?seatIncumbency parl:incumbencyStartDate ?seatIncumbencyStartDate .
          ?constituency parl:constituencyGroupName ?constituencyName .
          ?constituency parl:constituencyGroupStartDate ?constituencyStartDate .
		      OPTIONAL { ?constituency parl:constituencyGroupEndDate ?constituencyEndDate . }
        }
      }
    ")
  end

  def self.current_constituency(id)
    self.uri_builder("
       PREFIX parl: <http://id.ukpds.org/schema/>

       CONSTRUCT {
        ?person
              a parl:Person ;
              parl:personGivenName ?givenName ;
              parl:personFamilyName ?familyName .
    	  ?constituency
        	  a parl:ConstituencyGroup ;
            parl:constituencyGroupName ?constituencyName ;
        	  parl:constituencyGroupStartDate ?constituencyStartDate ;
            parl:constituencyGroupHasHouseSeat ?seat .
    	  ?seat
        	  a parl:HouseSeat ;
        	  parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:incumbencyStartDate ?seatIncumbencyStartDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .

        OPTIONAL {
    	    ?person parl:memberHasIncumbency ?seatIncumbency .
        	?seatIncumbency a parl:SeatIncumbency .
    	    FILTER NOT EXISTS { ?seatIncumbency a parl:PastIncumbency . }
    	    ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?seat .
    	    ?seat parl:houseSeatHasConstituencyGroup ?constituency .
          ?seatIncumbency parl:incumbencyStartDate ?seatIncumbencyStartDate .
          ?constituency parl:constituencyGroupName ?constituencyName .
          ?constituency parl:constituencyGroupStartDate ?constituencyStartDate .
        }
      }
    ")
  end

  def self.parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	?person a parl:Person ;
              parl:personGivenName ?givenName ;
              parl:personFamilyName ?familyName .
      ?party
        	  a parl:Party ;
            parl:partyName ?partyName ;
            parl:partyHasPartyMembership ?partyMembership .
    	?partyMembership
            a parl:PartyMembership ;
        	  parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	  parl:partyMembershipEndDate ?partyMembershipEndDate .
       }
       WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

          OPTIONAL { ?person parl:personGivenName ?givenName } .
          OPTIONAL { ?person parl:personFamilyName ?familyName } .

          OPTIONAL {
            ?person parl:partyMemberHasPartyMembership ?partyMembership .
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
            OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
            ?party parl:partyName ?partyName .
          }
       }
     ")
  end

  def self.current_party(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
    	?person a parl:Person ;
              parl:personGivenName ?givenName ;
              parl:personFamilyName ?familyName .
      ?party
        	  a parl:Party ;
            parl:partyName ?partyName ;
            parl:partyHasPartyMembership ?partyMembership .
    	?partyMembership
            a parl:PartyMembership ;
        	  parl:partyMembershipStartDate ?partyMembershipStartDate .
       }
       WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

          OPTIONAL { ?person parl:personGivenName ?givenName } .
          OPTIONAL { ?person parl:personFamilyName ?familyName } .

          OPTIONAL {
            ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	      FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
            ?party parl:partyName ?partyName .
    	    }
       }
    ")
  end

  def self.contact_points(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
          a parl:Person ;
          parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
          parl:personHasContactPoint ?contactPoint .
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
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

    	  OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .
        OPTIONAL {
	        ?person parl:personHasContactPoint ?contactPoint .
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
      }
    ")
  end

  def self.houses(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?person
            a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName .
    	  ?house
            a parl:House ;
    			  parl:houseName ?houseName ;
            parl:houseHasHouseSeat ?houseSeat .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:incumbencyEndDate ?incumbencyEndDate ;
        	  parl:incumbencyStartDate ?incumbencyStartDate .
    		?houseSeat
        		a parl:HouseSeat ;
        		parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    		?houseIncumbency
        		a parl:HouseIncumbency ;
        		parl:incumbencyEndDate ?incumbencyEndDate ;
        	  	parl:incumbencyStartDate ?incumbencyStartDate ;
        		parl:houseIncumbencyHasHouse ?house .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .

        OPTIONAL {
    	     ?person parl:memberHasIncumbency ?incumbency .
           OPTIONAL { ?incumbency parl:incumbencyEndDate ?incumbencyEndDate . }
    	     ?incumbency parl:incumbencyStartDate ?incumbencyStartDate .

           OPTIONAL {
        	   ?incumbency a parl:HouseIncumbency .
             BIND(?incumbency AS ?houseIncumbency )
             ?houseIncumbency parl:houseIncumbencyHasHouse ?house .
             ?house parl:houseName ?houseName .
        	 }
            OPTIONAL {
        	    ?incumbency a parl:SeatIncumbency .
              BIND(?incumbency AS ?seatIncumbency )
              ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?seat .
            	?seat parl:houseSeatHasConstituencyGroup ?constituency .
    	      	?seat parl:houseSeatHasHouse ?house .
            	?house parl:houseName ?houseName .
            	?constituency parl:constituencyGroupName ?constituencyName .
        	  }
        }
      }
    ")
  end

  def self.current_house(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?person
            a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName .
    	  ?house
            a parl:House ;
    			  parl:houseName ?houseName ;
            parl:houseHasHouseSeat ?houseSeat .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:incumbencyStartDate ?incumbencyStartDate .
    		?houseSeat
        		a parl:HouseSeat ;
        		parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    		?houseIncumbency
        		a parl:HouseIncumbency ;
        	  parl:incumbencyStartDate ?incumbencyStartDate ;
        		parl:houseIncumbencyHasHouse ?house .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?person)

        OPTIONAL { ?person parl:personGivenName ?givenName } .
        OPTIONAL { ?person parl:personFamilyName ?familyName } .

        OPTIONAL {
    	     ?person parl:memberHasIncumbency ?incumbency .
           FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }
    	     ?incumbency parl:incumbencyStartDate ?incumbencyStartDate .

           OPTIONAL {
        	   ?incumbency a parl:HouseIncumbency .
             BIND(?incumbency AS ?houseIncumbency )
             ?houseIncumbency parl:houseIncumbencyHasHouse ?house .
             ?house parl:houseName ?houseName .
        	 }
            OPTIONAL {
        	    ?incumbency a parl:SeatIncumbency .
              BIND(?incumbency AS ?seatIncumbency )
              ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?seat .
            	?seat parl:houseSeatHasConstituencyGroup ?constituency .
    	      	?seat parl:houseSeatHasHouse ?house .
            	?house parl:houseName ?houseName .
            	?constituency parl:constituencyGroupName ?constituencyName .
        	  }
        }
      }
    ")
  end

  def self.lookup_by_letters(letters)
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

    	  FILTER(regex(str(?familyName), \"#{letters}\", 'i') || regex(str(?givenName), \"#{letters}\", 'i')) .
      }
    ")
  end
end
