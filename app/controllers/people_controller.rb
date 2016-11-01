class PeopleController < ApplicationController
  def index
    data = PersonQueryObject.all
    format(data)
  end
end
