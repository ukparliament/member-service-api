class ConstituencyQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituencyGroup
            a parl:ConstituencyGroup ;
            parl:constituencyGroupName ?name .
      }
      WHERE {
      	?constituencyGroup a parl:ConstituencyGroup .
          OPTIONAL { ?constituency parl:constituencyGroupName ?name . }
      }
    ')
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituencyGroup
            a parl:ConstituencyGroup ;
            parl:constituencyGroupEndDate ?endDate ;
            parl:constituencyGroupStartDate ?startDate ;
         		parl:constituencyGroupName ?name ;
        	parl:constituencyGroupOnsCode ?onsCode ;
            parl:constituencyGroupHasConstituencyArea ?constituencyArea .
         	?constituencyArea
            a parl:ConstituencyArea ;
            parl:constituencyAreaLatitude ?latitude ;
         		parl:constituencyAreaLongitude ?longitude ;
        	  parl:constituencyAreaExtent ?polygon .
            ?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
            ?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
            ?seatIncumbency a parl:SeatIncumbency ;
                            parl:seatIncumbencyHasMember ?member ;
                            parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
                            parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
            ?member parl:personGivenName ?givenName ;
                    parl:personFamilyName ?familyName .
      }
      WHERE {
          ?constituencyGroup a parl:ConstituencyGroup .
          OPTIONAL { ?constituencyGroup parl:constituencyGroupEndDate ?endDate . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupStartDate ?startDate . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    	  OPTIONAL { ?constituencyGroup parl:constituencyGroupOnsCode ?onsCode . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupHasConstituencyArea ?constituencyArea .
            ?constituencyArea a parl:ConstituencyArea .
            OPTIONAL { ?constituencyArea parl:constituencyAreaLatitude ?latitude . }
            OPTIONAL { ?constituencyArea parl:constituencyAreaLongitude ?longitude . }
            OPTIONAL { ?constituencyArea parl:constituencyAreaExtent ?polygon . }
          }
          OPTIONAL {
            ?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
            ?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
      	    ?seatIncumbency a parl:SeatIncumbency ;
            OPTIONAL { ?seatIncumbency parl:seatIncumbencyHasMember ?member . }
            OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
            OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
            OPTIONAL { ?member parl:personGivenName ?givenName . }
            OPTIONAL { ?member parl:personFamilyName ?familyName . }
          }

          FILTER(?constituencyGroup=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.all_current
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituencyGroup
              a parl:ConstituencyGroup ;
              parl:constituencyGroupName ?name .
      }
      WHERE {
          ?constituencyGroup a parl:ConstituencyGroup .
          FILTER NOT EXISTS { ?constituency a parl:PastConstituencyGroup . }
          OPTIONAL { ?constituency parl:constituencyGroupName ?name . }
      }
    ')
  end

  def self.all_current_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituencyGroup
              a parl:ConstituencyGroup ;
              parl:constituencyGroupName ?name .
      }
      WHERE {
          ?constituencyGroup a parl:ConstituencyGroup .
          FILTER NOT EXISTS { ?constituencyGroup a parl:PastConstituencyGroup . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    		  FILTER regex(str(?name), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
    	   	?constituencyGroup
            	a parl:ConstituencyGroup ;
         		parl:constituencyGroupName ?name ;
         		parl:constituencyGroupHasHouseSeat ?houseSeat .
         	?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  	?seatIncumbency parl:seatIncumbencyHasMember ?member ;
          					      parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        					        parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
        	?member parl:personGivenName ?givenName ;
        			    parl:personFamilyName ?familyName .
      }
      WHERE {
    	  ?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
    	  OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    	  ?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  ?seatIncumbency parl:seatIncumbencyHasMember ?member .
          OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
        	OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
        	OPTIONAL { ?member parl:personGivenName ?givenName . }
        	OPTIONAL { ?member parl:personFamilyName ?familyName . }

        FILTER(?constituencyGroup=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.all_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituencyGroup
              a parl:ConstituencyGroup ;
              parl:constituencyGroupName ?name .
      }
      WHERE {
          ?constituencyGroup a parl:ConstituencyGroup .
          OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    		  FILTER regex(str(?name), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.current_member(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
    	   	?constituencyGroup
            	a parl:ConstituencyGroup ;
         		parl:constituencyGroupName ?name ;
         		parl:constituencyGroupHasHouseSeat ?houseSeat .
         	?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  	?seatIncumbency parl:seatIncumbencyHasMember ?member ;
          				        parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        					        parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
        	?member parl:personGivenName ?givenName ;
        			    parl:personFamilyName ?familyName .
      }
      WHERE {
    	  ?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
    	  OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    	  ?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  ?seatIncumbency parl:seatIncumbencyHasMember ?member .
        FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
          OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
        	OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
        	OPTIONAL { ?member parl:personGivenName ?givenName . }
        	OPTIONAL { ?member parl:personFamilyName ?familyName . }

        FILTER(?constituencyGroup=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.contact_point(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?constituency
            a parl:Constituency ;
         		parl:constituencyName ?name .
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
      	?constituency parl:constituencyHasConstituencyParty ?constituencyParty .
        ?constituencyParty parl:constituencyPartyHasContactPoint ?contactPoint .
        OPTIONAL{ ?contactPoint parl:email ?email . }
        OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
        OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
        OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
        OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
        OPTIONAL{ ?contactPoint parl:postalCode ?postalCode . }
        OPTIONAL { ?constituency parl:constituencyName ?name . }

      	FILTER(?constituency = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end
end