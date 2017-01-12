class HouseQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
          ?house a parl:House .
      }'
    )
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
          ?house a parl:House .

          FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	  ?house a parl:House .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingEndDate ?sittingEndDate ;
        	  parl:sittingStartDate ?sittingStartDate ;
        	  parl:connect ?member ;
            parl:relationship \"through\" .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	  ?house a parl:House .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingEndDate ?sittingEndDate ;
        	  parl:sittingStartDate ?sittingStartDate ;
        	  parl:connect ?member ;
            parl:relationship \"through\" .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
        FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.current_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	  ?house a parl:House .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingStartDate ?sittingStartDate ;
        	  parl:connect ?member ;
            parl:relationship \"through\" .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.current_members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
              parl:forename ?forename ;
              parl:surname ?surname .
    	  ?house a parl:House .
    	  ?sitting
            a parl:Sitting ;
        	  parl:sittingStartDate ?sittingStartDate ;
        	  parl:connect ?member ;
            parl:relationship \"through\" .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
        FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house a parl:House .
        ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
      WHERE {
        SELECT DISTINCT ?party ?partyName ?house
          WHERE {
            ?house parl:houseHasSeat ?seat.
            ?seat parl:seatHasSitting ?sitting .
            ?sitting parl:sittingHasPerson ?member .
            ?member parl:personHasPartyMembership ?partyMembership .
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?party parl:partyName ?partyName .

            FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
          }
        }
     ")
  end

  def self.current_parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house a parl:House .
        ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
      WHERE {
        SELECT DISTINCT ?party ?partyName ?house
          WHERE {
            ?house parl:houseHasSeat ?seat.
            ?seat parl:seatHasSitting ?sitting .
              FILTER NOT EXISTS { ?sitting a parl:PastThing . }
            ?sitting parl:sittingHasPerson ?member .
            ?member parl:personHasPartyMembership ?partyMembership .
              FILTER NOT EXISTS { ?partyMembership a parl:PastThing . }
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?party parl:partyName ?partyName .

            FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
          }
        }
     ")
  end
end
