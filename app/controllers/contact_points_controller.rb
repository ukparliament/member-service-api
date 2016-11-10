class ContactPointsController < ApplicationController
  def index
    data = ContactPointQueryObject.all
    format(data)
  end

  def show
    id = params[:id]
    data = ContactPointQueryObject.find(id)
    format(data)
  end
end
