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
        FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency .	}
        ?seatIncumbency parl:seatIncumbencyHasMember ?member ;
                        parl:seatIncumbencyHasHouseSeat ?houseSeat .
        ?member parl:partyMemberHasPartyMembership ?partyMembership .
        FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership .	}
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

  def self.all_current_by_letter(letter)
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
            FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency .	}
            ?seatIncumbency parl:seatIncumbencyHasMember ?member ;
                            parl:seatIncumbencyHasHouseSeat ?houseSeat .
            ?member parl:partyMemberHasPartyMembership ?partyMembership .
            FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership .	}
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
end