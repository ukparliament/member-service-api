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
end
