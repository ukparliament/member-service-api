class MemberQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
        PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
         ?seatIncumbency
           a parl:SeatIncumbency ;
           parl:seatIncumbencyHasMember ?member ;
           parl:seatIncumbencyHasHouseSeat ?houseSeat .
         ?member
           parl:personGivenName ?givenName ;
           parl:personFamilyName ?familyName ;
           parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership
           parl:partyMembershipHasParty ?party .
         ?party
           parl:partyName ?partyName .
         ?houseSeat
           parl:houseSeatHasHouse ?house ;
           parl:houseSeatHasConstituencyGroup ?constituencyGroup .
         ?house
           parl:houseName ?houseName .
         ?constituencyGroup
           parl:constituencyGroupName ?constituencyGroupName .
      }
      WHERE {
        ?seatIncumbency a parl:SeatIncumbency ;
                        parl:seatIncumbencyHasMember ?member ;
                        parl:seatIncumbencyHasHouseSeat ?houseSeat .
        ?member parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         ?party parl:partyName ?partyName .
         ?houseSeat parl:houseSeatHasHouse ?house ;
                    parl:houseSeatHasConstituencyGroup ?constituencyGroup .
         ?constituencyGroup parl:constituencyGroupName ?constituencyGroupName .
         ?house parl:houseName ?houseName .
    	 OPTIONAL { ?member parl:personGivenName ?givenName . }
    	 OPTIONAL { ?member parl:personFamilyName ?familyName . }
      }
    ')
  end

  def self.all_by_letter(letter)
    self.uri_builder("
    PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
         ?seatIncumbency
           a parl:SeatIncumbency ;
           parl:seatIncumbencyHasMember ?member ;
           parl:seatIncumbencyHasHouseSeat ?houseSeat .
         ?member
           parl:personGivenName ?givenName ;
           parl:personFamilyName ?familyName ;
           parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership
           parl:partyMembershipHasParty ?party .
         ?party
           parl:partyName ?partyName .
         ?houseSeat
           parl:houseSeatHasHouse ?house ;
           parl:houseSeatHasConstituencyGroup ?constituencyGroup .
         ?house
           parl:houseName ?houseName .
         ?constituencyGroup
           parl:constituencyGroupName ?constituencyGroupName .

      }
      WHERE {
        ?seatIncumbency a parl:SeatIncumbency ;
                        parl:seatIncumbencyHasMember ?member ;
                        parl:seatIncumbencyHasHouseSeat ?houseSeat .
        ?member parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         ?party parl:partyName ?partyName .
         ?houseSeat parl:houseSeatHasHouse ?house ;
                    parl:houseSeatHasConstituencyGroup ?constituencyGroup .
         ?constituencyGroup parl:constituencyGroupName ?constituencyGroupName .
         ?house parl:houseName ?houseName .
    	 OPTIONAL { ?member parl:personGivenName ?givenName . }
    	 OPTIONAL { ?member parl:personFamilyName ?familyName . }
    	  FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.all_current
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
        ?member
          a parl:Person ;
        	parl:forename ?forename ;
        	parl:surname ?surname .
    	?house a parl:House ;
        	parl:connect ?member .
    	?constituency a parl:Constituency ;
        	parl:constituencyName ?constituencyName;
         	parl:connect ?member .
    	?party a parl:Party ;
        	parl:partyName ?partyName;
        	parl:connect ?member .
      }
      WHERE {
        ?sitting a parl:Sitting .
        MINUS { ?sitting a parl:PastSitting .}
        ?sitting parl:sittingHasPerson ?member .
    	?sitting parl:sittingHasSeat ?seat .
    	?seat parl:seatHasHouse ?house ;
    	parl:seatHasConstituency ?constituency .
    	OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
    	?member parl:personHasPartyMembership ?partyMembership .
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    		FILTER NOT EXISTS { ?partyMembership a parl:PastThing . }
        	OPTIONAL { ?party parl:partyName ?partyName . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
      }
    ')
  end

  def self.all_current_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
        ?member
          a parl:Person ;
        	parl:forename ?forename ;
        	parl:surname ?surname .
    	?house a parl:House ;
        	parl:connect ?member .
    	?constituency a parl:Constituency ;
        	parl:constituencyName ?constituencyName;
         	parl:connect ?member .
    	?party a parl:Party ;
        	parl:partyName ?partyName;
        	parl:connect ?member .
      }
      WHERE {
        ?sitting a parl:Sitting .
        MINUS { ?sitting a parl:PastSitting .}
        ?sitting parl:sittingHasPerson ?member .
    	?sitting parl:sittingHasSeat ?seat .
    	?seat parl:seatHasHouse ?house ;
    	parl:seatHasConstituency ?constituency .
    	OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
    	?member parl:personHasPartyMembership ?partyMembership .
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    		FILTER NOT EXISTS { ?partyMembership a parl:PastThing . }
        	OPTIONAL { ?party parl:partyName ?partyName . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
    	  FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end
end