class PartyQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
              PREFIX parl: <http://id.ukpds.org/schema/>
              CONSTRUCT {
                 ?party parl:partyName ?partyName .
              }

              WHERE {
                  ?party a parl:Party ;
                  OPTIONAL{ ?party parl:partyName ?partyName . }
              }'
    )
  end

  def self.all_current
    self.uri_builder('
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?party parl:partyName ?partyName .
                }

                WHERE {
                    ?partyMembership a parl:PartyMembership .
                    FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
                    OPTIONAL { ?partyMembership parl:partyMembershipHasParty ?party . }
                    OPTIONAL { ?party parl:partyName ?partyName . }
                }
               ')
  end

  def self.all_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         ?party parl:partyName ?partyName .
      }
      WHERE {
          ?party a parl:Party ;
          OPTIONAL{ ?party parl:partyName ?partyName . }
          FILTER regex(str(?partyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         ?party
            a parl:Party ;
            parl:partyName ?partyName .
      }
      WHERE {
          ?party parl:partyName ?partyName .
          FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
      }
    ")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?member a parl:Member ;
                 parl:forename ?forename ;
                 parl:surname ?surname .
        _:x
                 parl:partyMembershipStartDate ?partyMembershipStartDate ;
                 parl:partyMembershipEndDate ?partyMembershipEndDate ;
                 parl:connect ?member ;
                 parl:objectId ?partyMembership .
      }
      WHERE {
        ?party parl:partyHasPartyMembership ?partyMembership .
        ?partyMembership parl:partyMembershipHasPerson ?member .
        OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
        OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
        ?member a parl:Member .
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .
        FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?member a parl:Member ;
                 parl:forename ?forename ;
                 parl:surname ?surname .
        _:x
                 parl:partyMembershipStartDate ?partyMembershipStartDate ;
                 parl:partyMembershipEndDate ?partyMembershipEndDate ;
                 parl:connect ?member ;
                 parl:objectId ?partyMembership .
      }
      WHERE {
        ?party parl:partyHasPartyMembership ?partyMembership .
        ?partyMembership parl:partyMembershipHasPerson ?member .
        OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
        OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
        ?member a parl:Member .
        OPTIONAL { ?member parl:forename ?forename } .
        OPTIONAL { ?member parl:surname ?surname } .
        FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
        FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.current_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         ?member a parl:Member ;
                 parl:forename ?forename ;
                 parl:surname ?surname .
        _:x      parl:partyMembershipStartDate ?partyMembershipStartDate ;
                 parl:connect ?member ;
                 parl:objectId ?partyMembership .
      }
      WHERE {
          ?party parl:partyHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
          ?partyMembership parl:partyMembershipHasPerson ?member .
          OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
          ?member a parl:Member .
          OPTIONAL { ?member parl:forename ?forename } .
          OPTIONAL { ?member parl:surname ?surname } .
          FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
        }
      ")
  end

  def self.current_members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         ?member a parl:Member ;
                 parl:forename ?forename ;
                 parl:surname ?surname .
        _:x      parl:partyMembershipStartDate ?partyMembershipStartDate ;
                 parl:connect ?member ;
                 parl:objectId ?partyMembership .
      }
      WHERE {
          ?party parl:partyHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
          ?partyMembership parl:partyMembershipHasPerson ?member .
          OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
          ?member a parl:Member .
          OPTIONAL { ?member parl:forename ?forename } .
          OPTIONAL { ?member parl:surname ?surname } .
          FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
          FILTER regex(str(?surname), \"^#{letter.upcase}\") .
        }
      ")
  end

end