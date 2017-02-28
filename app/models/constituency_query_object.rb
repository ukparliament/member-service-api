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
          OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
      }
    ')
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
    		  FILTER regex(str(?name), \"^#{letter}\", 'i') .
      }
    ")
  end

  def self.a_z_letters
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
	        ?s a parl:ConstituencyGroup .
          ?s parl:constituencyGroupName ?constituencyName .

          BIND(ucase(SUBSTR(?constituencyName, 1, 1)) as ?firstLetter)
        }
      }
    ')
  end

  def self.lookup(source, id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?constituency
           a parl:ConstituencyGroup .
      }
      WHERE {
        BIND(\"#{id}\" AS ?id)
        BIND(parl:#{source} AS ?source)

	      ?constituency a parl:ConstituencyGroup .
        ?constituency ?source ?id .
      }")
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
            ?houseSeat a parl:HouseSeat ;
              parl:houseSeatHasSeatIncumbency ?seatIncumbency .
            ?seatIncumbency a parl:SeatIncumbency ;
                            parl:seatIncumbencyHasMember ?member ;
                            parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
                            parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
            ?member a parl:Person ;
                    parl:personGivenName ?givenName ;
                    parl:personFamilyName ?familyName .
      }
      WHERE {
          BIND( <#{DATA_URI_PREFIX}/#{id}> AS ?constituencyGroup )
          ?constituencyGroup a parl:ConstituencyGroup .
          OPTIONAL { ?constituencyGroup parl:constituencyGroupEndDate ?endDate . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupStartDate ?startDate . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    	    OPTIONAL { ?constituencyGroup parl:constituencyGroupOnsCode ?onsCode . }
          OPTIONAL {
            ?constituencyGroup parl:constituencyGroupHasConstituencyArea ?constituencyArea .
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
      }
    ")
  end

  def self.by_identifier(source, id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
	      ?constituency a parl:Constituency .
      }
      WHERE {
	      ?constituency parl:#{source} \"#{id}\" .
      }")
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
          FILTER NOT EXISTS { ?constituencyGroup a parl:PastConstituencyGroup . }
          OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
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
    		  FILTER regex(str(?name), \"^#{letter}\", 'i') .
      }
    ")
  end

  def self.a_z_letters_current
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
	        ?s a parl:ConstituencyGroup .
          FILTER NOT EXISTS { ?s a parl:PastConstituencyGroup . }
          ?s parl:constituencyGroupName ?constituencyName .

          BIND(ucase(SUBSTR(?constituencyName, 1, 1)) as ?firstLetter)
        }
      }
    ')
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT{
    	   	?constituencyGroup
            a parl:ConstituencyGroup ;
         		parl:constituencyGroupName ?name ;
         		parl:constituencyGroupHasHouseSeat ?houseSeat .
         	?houseSeat a parl:HouseSeat ;
            parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  	?seatIncumbency a parl:SeatIncumbency ;
                          parl:seatIncumbencyHasMember ?member ;
          					      parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        					        parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
        	?member a parl:Person ;
                  parl:personGivenName ?givenName ;
        			    parl:personFamilyName ?familyName .
      }
      WHERE {
        BIND( <#{DATA_URI_PREFIX}/#{id}> AS ?constituencyGroup )
    	  ?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
    	  OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    	  OPTIONAL {
          ?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
          OPTIONAL {
    	      ?seatIncumbency parl:seatIncumbencyHasMember ?member .
              OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
        	    OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
        	    OPTIONAL { ?member parl:personGivenName ?givenName . }
        	    OPTIONAL { ?member parl:personFamilyName ?familyName . }
          }
        }
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
         	?houseSeat a parl:HouseSeat ;
                     parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	  	?seatIncumbency a parl:SeatIncumbency ;
                          parl:seatIncumbencyHasMember ?member ;
          				        parl:seatIncumbencyEndDate ?seatIncumbencyEndDate ;
        					        parl:seatIncumbencyStartDate ?seatIncumbencyStartDate .
        	?member a parl:Person ;
                  parl:personGivenName ?givenName ;
        			    parl:personFamilyName ?familyName .
      }
      WHERE {
        BIND( <#{DATA_URI_PREFIX}/#{id}> AS ?constituencyGroup )
    	  ?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
    	  OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
    	  OPTIONAL {
          ?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
          FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
          OPTIONAL {
    	      ?seatIncumbency parl:seatIncumbencyHasMember ?member .
            OPTIONAL { ?seatIncumbency parl:seatIncumbencyEndDate ?seatIncumbencyEndDate . }
        	  OPTIONAL { ?seatIncumbency parl:seatIncumbencyStartDate ?seatIncumbencyStartDate . }
        	  OPTIONAL { ?member parl:personGivenName ?givenName . }
        	  OPTIONAL { ?member parl:personFamilyName ?familyName . }
          }
        }
      }
    ")
  end

  def self.contact_point(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
      	?constituencyGroup a parl:ConstituencyGroup ;
        				parl:constituencyGroupHasHouseSeat ?houseSeat ;
        				parl:constituencyGroupName ?name .
        ?houseSeat a parl:HouseSeat ;
                parl:houseSeatHasSeatIncumbency ?seatIncumbency .
    	?seatIncumbency a parl:SeatIncumbency ;
                parl:seatIncumbencyHasContactPoint ?contactPoint .
        ?contactPoint a parl:ContactPoint ;
        			  parl:email ?email ;
                parl:phoneNumber ?phoneNumber ;
        			  parl:faxNumber ?faxNumber ;
    			      parl:contactForm ?contactForm ;
    	              parl:contactPointHasPostalAddress ?postalAddress .
        ?postalAddress a parl:PostalAddress ;
        			   parl:postCode ?postCode ;
       				   parl:addressLine1 ?addressLine1 ;
    				   parl:addressLine2 ?addressLine2 ;
    				   parl:addressLine3 ?addressLine3 ;
    				   parl:addressLine4 ?addressLine4 ;
    				   parl:addressLine5 ?addressLine5 .
      }
      WHERE {
    	BIND( <#{DATA_URI_PREFIX}/#{id}> AS ?constituencyGroup )
      	 OPTIONAL {
        	?constituencyGroup parl:constituencyGroupHasHouseSeat ?houseSeat .
        	OPTIONAL {
        		?houseSeat parl:houseSeatHasSeatIncumbency ?seatIncumbency .
        		FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
        		OPTIONAL {
            		?seatIncumbency parl:seatIncumbencyHasContactPoint ?contactPoint .
                    OPTIONAL{ ?contactPoint parl:email ?email . }
                    OPTIONAL{ ?contactPoint parl:phoneNumber ?phoneNumber . }
                    OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
                    OPTIONAL{ ?contactPoint parl:contactForm ?contactForm . }
                    OPTIONAL{ ?contactPoint parl:contactPointHasPostalAddress ?postalAddress .
                        OPTIONAL{ ?postalAddress parl:postCode ?postCode . }
                        OPTIONAL{ ?postalAddress parl:addressLine1 ?addressLine1 . }
                        OPTIONAL{ ?postalAddress parl:addressLine2 ?addressLine2 . }
                        OPTIONAL{ ?postalAddress parl:addressLine3 ?addressLine3 . }
                        OPTIONAL{ ?postalAddress parl:addressLine4 ?addressLine4 . }
                        OPTIONAL{ ?postalAddress parl:addressLine5 ?addressLine5 . }
                    }
                }
        		}
    		}
        OPTIONAL { ?constituencyGroup parl:constituencyGroupName ?name . }
      }
    ")
  end

  def self.lookup_by_letters(letters)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?constituency
        	a parl:ConstituencyGroup ;
         	parl:constituencyGroupName ?constituencyName .
      }
      WHERE {
        ?constituency a parl:ConstituencyGroup .
        ?constituency parl:constituencyGroupName ?constituencyName .

    	  FILTER(regex(str(?constituencyName), \"#{letters}\", 'i')) .
      }
    ")
  end
end