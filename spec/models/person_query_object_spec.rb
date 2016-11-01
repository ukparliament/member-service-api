require 'rails_helper'

describe 'PersonQueryObject' do

  describe '#all' do
    let(:result) { PersonQueryObject.all }

    before(:each) do
      VCR.insert_cassette("people_all")
    end

    it 'returns 16911 statements' do
      expect(result.count).to eq 16911
    end

    after(:each) do
      VCR.eject_cassette
    end
  end

end