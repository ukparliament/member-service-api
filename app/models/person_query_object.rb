class PersonQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>
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
      }'
    )
  end

  def self.find(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      PREFIX schema: <http://schema.org/>
      CONSTRUCT {
          ?person
              parl:dateOfBirth ?dateOfBirth ;
              parl:forename ?forename ;
              parl:middleName ?middleName ;
              parl:surname ?surname .
      }
      WHERE {
        OPTIONAL { ?person parl:forename ?forename } .
        OPTIONAL { ?person parl:middleName ?middleName } .
        OPTIONAL { ?person parl:surname ?surname } .
        OPTIONAL { ?person parl:dateOfBirth ?dateOfBirth } .
        FILTER (?person = <http://id.ukpds.org/#{id}> )
      }
    ")
  end

end