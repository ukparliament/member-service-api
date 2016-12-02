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
end