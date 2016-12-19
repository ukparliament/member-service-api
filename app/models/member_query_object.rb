class MemberQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
         ?member
           parl:forename ?forename ;
           parl:surname ?surname .
      }
      WHERE {
        ?member
          a parl:Member .
            OPTIONAL { ?member parl:forename ?forename } .
            OPTIONAL { ?member parl:surname ?surname } .
      }
    ')
  end

  def self.all_by_letter(letter)
    self.uri_builder("
       PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
         ?member
           parl:forename ?forename ;
           parl:surname ?surname .
      }
      WHERE {
        ?member a parl:Member .
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .
    	  FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.all_current
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
        ?member
        parl:forename ?forename ;
        parl:surname ?surname .
      }
      WHERE {
        ?sitting a parl:Sitting .
        MINUS { ?sitting a parl:PastSitting .}
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
      }
    ')
  end

  def self.all_current_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT{
        ?member
            parl:forename ?forename ;
            parl:surname ?surname .
      }
      WHERE {
        ?sitting a parl:Sitting .
        MINUS { ?sitting a parl:PastSitting .}
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }
    	  FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end
end