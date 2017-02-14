class HouseQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house
            a parl:House ;
        	  parl:houseName ?houseName .
      }
      WHERE {
          ?house
             a parl:House ;
    			   parl:houseName ?houseName .
      }'
    )
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house
            a parl:House ;
            parl:houseName ?houseName .
      }
      WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

          ?house
            a parl:House ;
            parl:houseName ?houseName .
      }")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:memberHasSeatIncumbency ?seatIncumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        	  parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
      	?house parl:houseHasHouseSeat ?seat .
        ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
        ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }
        OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
        OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:memberHasSeatIncumbency ?seatIncumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        	  parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
      	?house parl:houseHasHouseSeat ?seat .
        ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
        ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }
        OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
        OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }

        FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.current_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
        	  parl:partyMemberHasPartyMembership ?partyMembership ;
            parl:memberHasSeatIncumbency ?seatIncumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    		?seat
        		a parl:HouseSeat ;
        		parl:houseSeatHasConstituencyGroup ?constituency .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:seatIncumbencyHasHouseSeat ?seat .
    	  ?constituency
        	  a parl:ConstituencyGroup ;
        	  parl:constituencyGroupName ?constituencyName .
    	  ?partyMembership
        	  a parl:PartyMembership ;
        	  parl:partyMembershipHasParty ?party .
    	  ?party
        	  a parl:Party ;
        	  parl:partyName ?partyName .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
      	?house parl:houseHasHouseSeat ?seat .
        ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
        ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        OPTIONAL {
          ?seat parl:houseSeatHasConstituencyGroup ?constituency .
        	?constituency parl:constituencyGroupName ?constituencyName .
        }
    	  ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	  FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    	  ?party parl:partyName ?partyName .
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }
      }
    ")
  end

  def self.current_members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
        	  parl:partyMemberHasPartyMembership ?partyMembership ;
            parl:memberHasSeatIncumbency ?seatIncumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    		?seat
        		a parl:HouseSeat ;
        		parl:houseSeatHasConstituencyGroup ?constituency .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:seatIncumbencyHasHouseSeat ?seat .
    	  ?constituency
        	  a parl:ConstituencyGroup ;
        	  parl:constituencyGroupName ?constituencyName .
    	  ?partyMembership
        	  a parl:PartyMembership ;
        	  parl:partyMembershipHasParty ?party .
    	  ?party
        	  a parl:Party ;
        	  parl:partyName ?partyName .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
      	?house parl:houseHasHouseSeat ?seat .
        ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
        ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        OPTIONAL {
          ?seat parl:houseSeatHasConstituencyGroup ?constituency .
        	?constituency parl:constituencyGroupName ?constituencyName .
        }
    	  ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	  FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    	  ?party parl:partyName ?partyName .
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

        FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house
        	a parl:House ;
        	parl:houseName ?houseName .
        ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
      WHERE {
        SELECT DISTINCT ?party ?partyName ?house ?houseName
          WHERE {
        	  BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

            ?house parl:houseHasHouseSeat ?seat.
        	  ?house parl:houseName ?houseName .
            ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
            ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        	  OPTIONAL {
              	?person parl:partyMemberHasPartyMembership ?partyMembership .
              	?partyMembership parl:partyMembershipHasParty ?party .
              	?party parl:partyName ?partyName .
        	  }
          }
        }
    ")
  end

  def self.current_parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house
        	a parl:House ;
        	parl:houseName ?houseName .
        ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
      WHERE {
        SELECT DISTINCT ?party ?partyName ?house ?houseName
          WHERE {
        	  BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

            ?house parl:houseHasHouseSeat ?seat.
        	  ?house parl:houseName ?houseName .
            ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
        	  FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
            ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        	  OPTIONAL {
              ?person parl:partyMemberHasPartyMembership ?partyMembership .
              FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
              ?partyMembership parl:partyMembershipHasParty ?party .
              ?party parl:partyName ?partyName .
        	  }
          }
        }
     ")
  end

  def self.party(house_id, party_id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house
            a parl:House ;
            parl:houseName ?houseName .
          ?party
            a parl:Party ;
            parl:partyName ?partyName .
      }
      WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

          OPTIONAL {
            BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

            ?house parl:houseHasHouseSeat ?seat .
            ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
            ?seatIncumbency parl:seatIncumbencyHasMember ?member .
            ?member parl:partyMemberHasPartyMembership ?partyMembership .
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?party parl:partyName ?partyName .
          }
      }")
  end

  def self.party_members(house_id, party_id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasSeatIncumbency ?seatIncumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	parl:partyMembershipEndDate ?partyMembershipEndDate .
    	?seatIncumbency
        	a parl:seatIncumbency ;
        	parl:seatIncumbencyStartDate ?seatIncumbencyStartDate ;
        	parl:seatIncumbencyEndDate ?seatIncumbencyEndDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    	    ?house parl:houseHasHouseSeat ?seat .
    	    ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	    ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
    	    OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }

    	    ?seatIncumbency parl:seatIncumbencyHasMember ?person .
    	    OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    	    ?party parl:partyName ?partyName .
    	    ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
    	    OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
        }
      }
    ")
  end

  def self.party_members_letters(house_id, party_id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasSeatIncumbency ?seatIncumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	parl:partyMembershipEndDate ?partyMembershipEndDate .
    	?seatIncumbency
        	a parl:seatIncumbency ;
        	parl:seatIncumbencyStartDate ?seatIncumbencyStartDate ;
        	parl:seatIncumbencyEndDate ?seatIncumbencyEndDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    	    ?house parl:houseHasHouseSeat ?seat .
    	    ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	    ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
    	    OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }

    	    ?seatIncumbency parl:seatIncumbencyHasMember ?person .
    	    OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    	    ?party parl:partyName ?partyName .
    	    ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
    	    OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }

          FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
        }
      }
    ")
  end

  def self.current_party_members(house_id, party_id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasSeatIncumbency ?seatIncumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate .
    	?seatIncumbency
        	a parl:seatIncumbency ;
        	parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    	    ?house parl:houseHasHouseSeat ?seat .
    	    ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
          FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
    	    ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .

    	    ?seatIncumbency parl:seatIncumbencyHasMember ?person .
    	    OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    	    ?party parl:partyName ?partyName .
    	    ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
        }
      }
    ")
  end

  def self.current_party_members_letters(house_id, party_id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasSeatIncumbency ?seatIncumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate .
    	?seatIncumbency
        	a parl:seatIncumbency ;
        	parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    	    ?house parl:houseHasHouseSeat ?seat .
    	    ?seat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
          FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
    	    ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .

    	    ?seatIncumbency parl:seatIncumbencyHasMember ?person .
    	    OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    	    ?party parl:partyName ?partyName .
    	    ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .

          FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
        }
      }
    ")
  end
end
