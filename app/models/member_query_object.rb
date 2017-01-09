class MemberQueryObject
  extend QueryObject

  def self.all
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
        ?sitting parl:sittingHasPerson ?member .
    	  ?sitting parl:sittingHasSeat ?seat .
    	  ?seat parl:seatHasHouse ?house ;
    		      parl:seatHasConstituency ?constituency .
    	  OPTIONAL { ?constituency parl:constituencyName ?constituencyName . }
    	  ?member parl:personHasPartyMembership ?partyMembership .
    	  ?partyMembership parl:partyMembershipHasParty ?party .
        OPTIONAL { ?party parl:partyName ?partyName . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
      }
    ')
  end

  def self.all_by_letter(letter)
    self.uri_builder("
       PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
         ?member
           parl:forename ?forename ;
           parl:surname ?surname .
      }
      WHERE {
        ?member a parl:Member .
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .
    	  FILTER regex(str(?surname), \"^#{letter.upcase}\") .
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