class HouseQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
          ?house a parl:House .
      }'
    )
  end

  def self.find(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
          ?house a parl:House .

          FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }")
  end
end
