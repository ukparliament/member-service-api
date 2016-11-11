class PartyQueryObject
  extend QueryObject

  def self.all
    self.query('
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
    self.query('
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?party parl:partyName ?partyName .
                }

                WHERE {
                    ?partyMembership a parl:PartyMembership .
                    MINUS { ?partyMembership a parl:PastPartyMembership . }
                    ?partyMembeship parl:partyMembershipHasParty ?party .
                    ?party parl:partyName ?partyName .
                }
               ')
  end

  def self.find(id)
    self.query("
              PREFIX parl: <http://id.ukpds.org/schema/>
              CONSTRUCT {
                 ?party parl:partyName ?partyName .
              }

              WHERE {
                  ?party parl:partyName ?partyName .
                  FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
              }
    ")
  end

end