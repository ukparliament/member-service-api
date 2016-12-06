class PartiesController < ApplicationController
  def index
    data = PartyQueryObject.all
    format(data)
  end

  def current
    data = PartyQueryObject.all_current
    format(data)
  end

  def show
    id = params[:id]
    data = PartyQueryObject.find(id)
    format(data)
  end

  def members
    id = params[:party_id]
    data = PartyQueryObject.members(id)
    format(data)
  end

  def current_members
    id = params[:party_id]
    data = PartyQueryObject.current_members(id)
    format(data)
  end

  def letters
    letter = params[:letter]
    data = PartyQueryObject.all_by_letter(letter)
    format(data)
  end

  def members_letters
    letter = params[:letter]
    id = params[:party_id]
    data = PartyQueryObject.members_by_letter(id, letter)
    format(data)
  end

  def current_members_letters
    letter = params[:letter]
    id = params[:party_id]
    data = PartyQueryObject.current_members_by_letter(id, letter)
    format(data)
  end
end
