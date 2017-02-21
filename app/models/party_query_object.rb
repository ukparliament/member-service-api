class PartyQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?party
           a parl:Party ;
           parl:partyName ?partyName .
      }
      WHERE {
	      ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
    ')
  end

  def self.all_current
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party
              a parl:Party ;
            	parl:partyName ?partyName .
      }
      WHERE {
      	?seatIncumbency a parl:SeatIncumbency .
        FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
        ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        ?person parl:partyMemberHasPartyMembership ?partyMembership .
        FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
        ?partyMembership parl:partyMembershipHasParty ?party .
        ?party parl:partyName ?partyName .
      }
    ')
  end

  def self.all_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party
           a parl:Party ;
           parl:partyName ?partyName .
      }
      WHERE {
        ?party a parl:Party ;
              parl:partyName ?partyName .

        FILTER regex(str(?partyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.find(id)
    self.uri_builder("
     PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
	      ?party a parl:Party;
               parl:partyName ?name
     }
     WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?party)

	      ?party parl:partyName ?name
      }
    ")
  end

  def self.by_identifier(source, id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
	      ?party a parl:Party .
      }
      WHERE {
	      ?party parl:#{source} \"#{id}\" .
      }")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:partyMemberHasPartyMembership ?partyMembership .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate ;
            parl:partyMembershipEndDate ?endDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?party)

      	?party parl:partyName ?partyName .

        OPTIONAL {
          ?party parl:partyHasPartyMembership ?partyMembership .
          ?partyMembership parl:partyMembershipHasPartyMember ?person .
          ?partyMembership parl:partyMembershipStartDate ?startDate .
          OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?endDate . }

          OPTIONAL { ?person parl:personGivenName ?givenName . }
          OPTIONAL { ?person parl:personFamilyName ?familyName . }
        }
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:partyMemberHasPartyMembership ?partyMembership .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate ;
            parl:partyMembershipEndDate ?endDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?party)

      	?party parl:partyName ?partyName .
        OPTIONAL {
          ?party parl:partyHasPartyMembership ?partyMembership .
          ?partyMembership parl:partyMembershipHasPartyMember ?person .
          ?partyMembership parl:partyMembershipStartDate ?startDate .
          OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?endDate . }

          OPTIONAL { ?person parl:personGivenName ?givenName . }
          OPTIONAL { ?person parl:personFamilyName ?familyName . }

          FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
        }
      }
    ")
  end

  def self.current_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:partyMemberHasPartyMembership ?partyMembership .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?party)

      	?party parl:partyName ?partyName .

        OPTIONAL {
          ?party parl:partyHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
          ?partyMembership parl:partyMembershipHasPartyMember ?person .
          ?person parl:memberHasSeatIncumbency ?seatIncumbency .
          FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
          ?partyMembership parl:partyMembershipStartDate ?startDate .

          OPTIONAL { ?person parl:personGivenName ?givenName . }
          OPTIONAL { ?person parl:personFamilyName ?familyName . }
        }
      }
      ")
  end

  def self.current_members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:partyMemberHasPartyMembership ?partyMembership .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?party)

      	?party parl:partyName ?partyName .

        OPTIONAL {
          ?party parl:partyHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
          ?partyMembership parl:partyMembershipHasPartyMember ?person .
          ?person parl:memberHasSeatIncumbency ?seatIncumbency .
          FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
          ?partyMembership parl:partyMembershipStartDate ?startDate .

          OPTIONAL { ?person parl:personGivenName ?givenName . }
          OPTIONAL { ?person parl:personFamilyName ?familyName . }
        }
          FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
       }
     ")
  end

  def self.lookup_by_letters(letters)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party
        	a parl:Party ;
         	parl:partyName ?partyName .
      }
      WHERE {
        ?party a parl:Party .
        ?party parl:partyName ?partyName .

    	  FILTER(regex(str(?partyName), \"#{letters}\", 'i')) .
      }
    ")
  end
end