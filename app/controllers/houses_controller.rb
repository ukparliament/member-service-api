class HousesController < ApplicationController
  def index
    data = HouseQueryObject.all
    format(data)
  end

  def show
    id = params[:id]
    data = HouseQueryObject.find(id)
    format(data)
  end

  def members
    id = params[:house_id]
    data = HouseQueryObject.members(id)
    format(data)
  end

  def current_members
    id = params[:house_id]
    data = HouseQueryObject.current_members(id)
    format(data)
  end

  def parties
    id = params[:house_id]
    data = HouseQueryObject.parties(id)
    format(data)
  end

  def current_parties
    id = params[:house_id]
    data = HouseQueryObject.current_parties(id)
    format(data)
  end

  def members_letters
    letter = params[:letter]
    id = params[:house_id]
    data = HouseQueryObject.members_by_letter(id, letter)
    format(data)
  end

  def current_members_letters
    letter = params[:letter]
    id = params[:house_id]
    data = HouseQueryObject.current_members_by_letter(id, letter)
    format(data)
  end
end