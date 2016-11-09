class PeopleController < ApplicationController
  def index
    data = PersonQueryObject.all
    format(data)
  end

  def show
    id = params[:id]
    data = PersonQueryObject.find(id)
    format(data)
  end
end
