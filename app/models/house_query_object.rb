class HouseQueryObject
  extend QueryObject

  def self.all
    self.query('
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
    self.query("
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
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
                  parl:forename ?forename ;
              	  parl:surname ?surname .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }")
  end

  def self.current_members(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
                  parl:forename ?forename ;
                  parl:surname ?surname .
          _:x parl:sittingStartDate ?sittingStartDate ;
              parl:connect ?member ;
              parl:objectId ?sitting .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        MINUS{ ?sitting a parl:PastSitting . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end
end
