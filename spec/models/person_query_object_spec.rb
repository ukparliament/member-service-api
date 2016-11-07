require 'rails_helper'

describe 'PersonQueryObject' do

  describe '#all' do
    let(:result) { PersonQueryObject.all }

    before(:each) do
      VCR.insert_cassette("people_all")
    end

    it 'returns 16910 statements' do
      expect(result.count).to eq 16910
    end

    after(:each) do
      VCR.eject_cassette
    end
  end

end