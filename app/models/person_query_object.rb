class PersonQueryObject
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
                      parl:dateOfBirth ?dateOfBirth .
              }
              WHERE {
                ?person
                  a schema:Person .
                      OPTIONAL { ?person parl:forename ?forename . }
                    OPTIONAL { ?person parl:middleName ?middleName } .
                    OPTIONAL { ?person parl:surname ?surname } .
                    OPTIONAL { ?person parl:dateOfBirth ?dateOfBirth . }
                    OPTIONAL { ?person parl:middleName ?middleName } .
              }'
    )
  end

end