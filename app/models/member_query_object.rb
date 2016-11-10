class MemberQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
         ?member
           parl:forename ?forename ;
           parl:middleName ?middleName ;
           parl:surname ?surname ;
      }
      WHERE {
        ?member
          a parl:Member .
            OPTIONAL { ?member parl:forename ?forename } .
            OPTIONAL { ?member parl:middleName ?middleName } .
            OPTIONAL { ?member parl:surname ?surname } .
      }
    ')
  end

  def self.all_current
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
        ?member
        parl:forename ?forename ;
        parl:middleName ?middleName ;
        parl:surname ?surname .
      }
      WHERE {
        ?sitting a parl:Sitting .
        MINUS { ?sitting a parl:PastSitting .}
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:middleName ?middleName . }
        OPTIONAL { ?member parl:surname ?surname . }
      }
    ')
  end
end