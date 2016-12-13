class HousesController < ApplicationController
  def index
    uri = HouseQueryObject.all
    response_streamer(uri)
  end

  def show
    id = params[:id]
    uri = HouseQueryObject.find(id)
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
end