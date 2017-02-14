class ContactPointsController < ApplicationController
  def index
    uri = ContactPointQueryObject.all
    response_streamer(uri)
  end

  def show
    id = params[:id]
    uri = ContactPointQueryObject.find(id)
    response_streamer(uri)
  end

  def by_identifier
    id = params.values.first
    source = params.keys.first
    uri = ContactPointQueryObject.by_identifier(source, id)
    response_streamer(uri)
  end
end
