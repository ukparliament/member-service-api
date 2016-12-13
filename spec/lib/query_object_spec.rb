require 'rails_helper'
require 'query_object'
require 'test_stubs/query_object_stubs'

describe QueryObject do
  let(:extended_class) { Class.new { extend QueryObject } }

  describe '#query' do
    it 'returns a graph with the right person when asked for a person by date of birth' do
      VCR.use_cassette("query_object") do
        graph = extended_class.uri_builder("
          PREFIX parl: <http://id.ukpds.org/schema/>
          PREFIX schema: <http://schema.org/>
          PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
          CONSTRUCT {
              ?person
                  parl:forename ?forename ;
                  parl:middleName ?middleName ;
                  parl:surname ?surname .
          }
          where {
            ?person
                  a schema:Person ;
                  parl:dateOfBirth '1925-02-28'^^xsd:date ;
                  parl:forename ?forename ;
                  parl:middleName ?middleName ;
                  parl:surname ?surname .
         }")
        expect(graph.to_s).to eq QUERY_BY_BIRTHDATE_GRAPH.to_s
      end
    end
  end
end