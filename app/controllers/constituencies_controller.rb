class ConstituenciesController < ApplicationController
  def index
    data = ConstituencyQueryObject.all
    format(data)
  end

  def show
    constituency_id = params[:id]
    data = ConstituencyQueryObject.find(constituency_id)
    format(data)
  end
end