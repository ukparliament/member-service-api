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
          			parl:constituencyLongitude ?longitude .
      }
      WHERE {
          OPTIONAL { ?constituency parl:constituencyEndDate ?endDate . }
          OPTIONAL { ?constituency parl:constituencyStartDate ?startDate . }
          OPTIONAL { ?constituency parl:constituencyName ?name . }
          OPTIONAL { ?constituency parl:constituencyLatitude ?latitude . }
          OPTIONAL { ?constituency parl:constituencyLongitude ?longitude . }

          FILTER(?constituency=<http://id.ukpds.org/#{id}>)
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
          ?sitting parl:startDate ?startDate ;
        			     parl:endDate ?endDate .
    	    ?member parl:forename ?forename ;
    			        parl:middleName ?middleName ;
        		      parl:surname ?surname .
      }
      WHERE {
    	  ?constituency parl:constituencyHasSeat ?seat .
    	  ?seat parl:seatHasSitting ?sitting .
    	  ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?sitting parl:endDate ?endDate . }
        OPTIONAL { ?sitting parl:startDate ?startDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:middleName ?middleName . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?constituency=<http://id.ukpds.org/#{id}>)
      }
    ")
  end

  def self.current_members(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
         ?sitting parl:startDate ?startDate ;
        			    parl:endDate ?endDate .
    	  ?member parl:forename ?forename ;
    			      parl:middleName ?middleName ;
        		    parl:surname ?surname .
      }
      WHERE {
    	  ?constituency parl:constituencyHasSeat ?seat .
    	  ?seat parl:seatHasSitting ?sitting .
    	  MINUS { ?sitting a parl:PastSitting . }
    	  ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?sitting parl:endDate ?endDate . }
        OPTIONAL { ?sitting parl:startDate ?startDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:middleName ?middleName . }
		    OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?constituency=<http://id.ukpds.org/#{id}>)
      }
    ")
  end
end