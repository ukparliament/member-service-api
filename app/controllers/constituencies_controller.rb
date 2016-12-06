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

  def current
    data = ConstituencyQueryObject.all_current
    format(data)
  end

  def members
    constituency_id = params[:constituency_id]
    data = ConstituencyQueryObject.members(constituency_id)
    format(data)
  end

  def current_members
    constituency_id = params[:constituency_id]
    data = ConstituencyQueryObject.current_members(constituency_id)
    format(data)
  end

  def contact_point
    constituency_id = params[:constituency_id]
    data = ConstituencyQueryObject.contact_point(constituency_id)
    format(data)
  end

  def letters
    letter = params[:letter]
    data = ConstituencyQueryObject.all_by_letter(letter)
    format(data)
  end

  def current_letters
    letter = params[:letter]
    data = ConstituencyQueryObject.all_current_by_letter(letter)
    format(data)
  end
end