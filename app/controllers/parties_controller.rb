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

  def all_members
    id = params[:party_id]
    data = PartyQueryObject.all_members(id)
    format(data)
  end

  def all_current_members
    id = params[:party_id]
    data = PartyQueryObject.all_current_members(id)
    format(data)
  end
end
