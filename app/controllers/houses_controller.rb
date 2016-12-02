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
end