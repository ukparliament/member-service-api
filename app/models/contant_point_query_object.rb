class ContactPointQueryObject
  extend QueryObject

  def self.all
    self.query('
              prefix parl: <http://id.ukpds.org/schema/>
              PREFIX schema: <http://schema.org/>

              CONSTRUCT {
                ?person
                  parl:forename ?forename ;
                  parl:middleName ?middleName ;
                  parl:surname ?surname ;
              }
              WHERE {
                ?person
                  a schema:Person .
                    OPTIONAL { ?person parl:forename ?forename } .
                    OPTIONAL { ?person parl:middleName ?middleName } .
                    OPTIONAL { ?person parl:surname ?surname } .
                    OPTIONAL { ?person parl:middleName ?middleName } .
              }'
    )
  end
  #
  # def self.find(id)
  #   self.query("
  #                 PREFIX parl: <http://id.ukpds.org/schema/>
  #                 CONSTRUCT {
  #                    ?contactPoint parl:email ?email ;
  #                                   parl:telephone ?telephone ;
  #                                   parl:faxNumber ?faxNumber ;
  #                                   parl:streetAddress ?streetAddress ;
  #                                   parl:addressLocality ?addressLocality ;
  #                                   parl:postalCode ?postalCode .
  #                 }
  #
  #                 WHERE {
  #                     ?contactPoint a parl:ContactPoint ;
  #                       OPTIONAL{ ?contactPoint parl:email ?email . }
  #                       OPTIONAL{ ?contactPoint parl:telephone ?telephone . }
  #                       OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
  #                       OPTIONAL{ ?contactPoint parl:streetAddress ?streetAddress . }
  #                       OPTIONAL{ ?contactPoint parl:addressLocality ?addressLocality . }
  #                       OPTIONAL{ ?contactPoint parl:postalCode ?postalCode . }
  #                       FILTER (?contactPoint = <http://id.ukpds.org/#{id}>)
  #                 }
  #               ")
  # end

end