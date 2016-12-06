class SittingsController < ApplicationController
  def person
    id = params[:sitting_id]
    data = SittingQueryObject.person(id)
    format(data)
  end

  def house
    id = params[:sitting_id]
    data = SittingQueryObject.house(id)
    format(data)
  end

  def constituency
    id = params[:sitting_id]
    data = SittingQueryObject.constituency(id)
    format(data)
  end
end