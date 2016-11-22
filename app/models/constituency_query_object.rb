class ConstituencyQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituency parl:constituencyEndDate ?endDate ;
          			parl:constituencyStartDate ?startDate ;
         				parl:constituencyName ?name ;
      }
      WHERE {
      	?constituency a parl:Constituency .
          OPTIONAL { ?constituency parl:constituencyEndDate ?endDate . }
          OPTIONAL { ?constituency parl:constituencyStartDate ?startDate . }
          OPTIONAL { ?constituency parl:constituencyName ?name . }
      }
    ')
  end

  def self.find(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituency parl:constituencyEndDate ?endDate ;
          			parl:constituencyStartDate ?startDate ;
         				parl:constituencyName ?name ;
          			parl:constituencyLatitude ?latitude ;
          			parl:constituencyLongitude ?longitude ;
        			  parl:constituencyExtent ?polygon ;
                parl:constituencyOnsCode ?onsCode .
      }
      WHERE {
          ?constituency a parl:Constituency .
          OPTIONAL { ?constituency parl:constituencyEndDate ?endDate . }
          OPTIONAL { ?constituency parl:constituencyStartDate ?startDate . }
          OPTIONAL { ?constituency parl:constituencyName ?name . }
          OPTIONAL { ?constituency parl:constituencyLatitude ?latitude . }
          OPTIONAL { ?constituency parl:constituencyLongitude ?longitude . }
    	    OPTIONAL { ?constituency parl:constituencyExtent ?polygon . }
          OPTIONAL { ?constituency parl:constituencyOnsCode ?onsCode . }

          FILTER(?constituency=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.all_current
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?constituency parl:constituencyEndDate ?endDate ;
          			parl:constituencyStartDate ?startDate ;
         				parl:constituencyName ?name ;
      }
      WHERE {
          ?constituency a parl:Constituency .
          MINUS { ?constituency a parl:PastConstituency . }
          OPTIONAL { ?constituency parl:constituencyEndDate ?endDate . }
          OPTIONAL { ?constituency parl:constituencyStartDate ?startDate . }
          OPTIONAL { ?constituency parl:constituencyName ?name . }
      }
    ')
  end

  def self.members(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
          ?sitting a parl:Sitting ;
                  parl:sittingStartDate ?sittingStartDate ;
        			     parl:sittingEndDate ?sittingEndDate ;
                    parl:sittingHasPerson ?member .
    	    ?member a parl:Member ;
                  parl:forename ?forename ;
    			        parl:middleName ?middleName ;
        		      parl:surname ?surname .
      }
      WHERE {
    	  ?constituency parl:constituencyHasSeat ?seat .
    	  ?seat parl:seatHasSitting ?sitting .
    	  ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?sitting parl:endDate ?sittingEndDate . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:middleName ?middleName . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?constituency=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.current_members(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
         ?sitting a parl:Sitting ;
                  parl:sittingStartDate ?startDate ;
        			    parl:sittingEndDate ?endDate ;
                  parl:sittingHasPerson ?member .
    	  ?member a parl:Member ;
                parl:forename ?forename ;
    			      parl:middleName ?middleName ;
        		    parl:surname ?surname .
      }
      WHERE {
    	  ?constituency parl:constituencyHasSeat ?seat .
    	  ?seat parl:seatHasSitting ?sitting .
    	  FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
    	  ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?sitting parl:endDate ?endDate . }
        OPTIONAL { ?sitting parl:startDate ?startDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:middleName ?middleName . }
		    OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?constituency=<#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.contact_point(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?contactPoint parl:email ?email ;
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

      	FILTER(?constituency = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end
end