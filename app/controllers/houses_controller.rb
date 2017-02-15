class HousesController < ApplicationController
  def index
    uri = HouseQueryObject.all
    response_streamer(uri)
  end

  def show
    id = params[:house]
    uri = HouseQueryObject.find(id)
    response_streamer(uri)
  end

  def by_identifier
    id = params.values.first
    source = params.keys.first
    uri = HouseQueryObject.by_identifier(source, id)
    response_streamer(uri)
  end

  def members
    id = params[:house_id]
    uri = HouseQueryObject.members(id)
    response_streamer(uri)
  end

  def current_members
    id = params[:house_id]
    uri = HouseQueryObject.current_members(id)
    response_streamer(uri)
  end

  def parties
    id = params[:house_id]
    uri = HouseQueryObject.parties(id)
    response_streamer(uri)
  end

  def current_parties
    id = params[:house_id]
    uri = HouseQueryObject.current_parties(id)
    response_streamer(uri)
  end

  def members_letters
    letter = params[:letter]
    id = params[:house_id]
    uri = HouseQueryObject.members_by_letter(id, letter)
    response_streamer(uri)
  end

  def current_members_letters
    letter = params[:letter]
    id = params[:house_id]
    uri = HouseQueryObject.current_members_by_letter(id, letter)
    response_streamer(uri)
  end

  def party
    house_id = params[:house_id]
    party_id = params[:party_id]
    uri = HouseQueryObject.party(house_id, party_id)
    response_streamer(uri)
  end

  def party_members
    house_id = params[:house_id]
    party_id = params[:party_id]
    uri = HouseQueryObject.party_members(house_id, party_id)
    response_streamer(uri)
  end

  def party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]
    uri = HouseQueryObject.party_members_letters(house_id, party_id, letter)
    response_streamer(uri)
  end

  def current_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]
    uri = HouseQueryObject.current_party_members(house_id, party_id)
    response_streamer(uri)
  end

  def current_party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]
    uri = HouseQueryObject.current_party_members_letters(house_id, party_id, letter)
    response_streamer(uri)
  end

  def lookup_by_letters
    letters = params[:letters]
    uri = HouseQueryObject.lookup_by_letters(letters)
    response_streamer(uri)
  end
end