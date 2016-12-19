class SittingsController < ApplicationController
  def person
    id = params[:sitting_id]
    uri = SittingQueryObject.person(id)
    response_streamer(uri)
  end

  def house
    id = params[:sitting_id]
    uri = SittingQueryObject.house(id)
    response_streamer(uri)
  end

  def constituency
    id = params[:sitting_id]
    uri = SittingQueryObject.constituency(id)
    response_streamer(uri)
  end
end