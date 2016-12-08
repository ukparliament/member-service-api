class ContactPointQueryObject
  extend QueryObject

  def self.all
    self.query('
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
                  ?contactPoint a parl:ContactPoint ;
                      MINUS { ?contactPoint a parl:Postal}
                    OPTIONAL{ ?contactPoint parl:email ?email . }
                    OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
                    OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
                    OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
                    OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
                    OPTIONAL{ ?contactPoint parl:postalCode ?postalCode . }
              }'
    )
  end

  def self.find(id)
    self.query("
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?contactPoint parl:email ?email ;
                                 parl:telephone ?telephone ;
                                 parl:faxNumber ?faxNumber ;
                                 parl:streetAddress ?streetAddress ;
                                 parl:addressLocality ?addressLocality ;
                                 parl:postalCode ?postalCode ;
    						                 parl:owner ?name .
                }
                WHERE {
                    ?contactPoint a parl:ContactPoint ;
                      OPTIONAL{ ?contactPoint parl:email ?email . }
                      OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
                      OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
                      OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
                      OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
                      OPTIONAL{ ?contactPoint parl:postalCode ?postalCode ;
                                              parl:contactPointHasSitting ?sitting .
        				                ?sitting parl:sittingHasPerson ?person .
    					                  ?person parl:forename ?forename ;
    					  		                    parl:surname ?surname .
    					                  BIND(CONCAT(?forename, ' ', ?surname) AS ?name)
   					          }
   						        OPTIONAL{ ?contactPoint parl:contactPointHasConstituencyParty ?cparty .
    					 		              ?cparty parl:constituencyPartyHasConstituency ?constituency .
    							              ?constituency parl:constituencyName ?name . }
                    FILTER (?contactPoint = <#{DATA_URI_PREFIX}/#{id}>)
                  }
                ")
  end

end