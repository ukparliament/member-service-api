class ConstituenciesController < ApplicationController
  def index
    uri = ConstituencyQueryObject.all
    response_streamer(uri)
  end

  def lookup
    source = params['source']
    id = params['id']
    uri = ConstituencyQueryObject.lookup(source, id)
    response_streamer(uri)
  end

  def show
    constituency_id = params[:constituency]
    uri = ConstituencyQueryObject.find(constituency_id)
    response_streamer(uri)
  end

  def by_identifier
    id = params.values.first
    source = params.keys.first
    uri = ConstituencyQueryObject.by_identifier(source, id)
    response_streamer(uri)
  end

  def current
    uri = ConstituencyQueryObject.all_current
    response_streamer(uri)
  end

  def members
    constituency_id = params[:constituency_id]
    uri = ConstituencyQueryObject.members(constituency_id)
    response_streamer(uri)
  end

  def current_member
    constituency_id = params[:constituency_id]
    uri = ConstituencyQueryObject.current_member(constituency_id)
    response_streamer(uri)
  end

  def contact_point
    constituency_id = params[:constituency_id]
    uri = ConstituencyQueryObject.contact_point(constituency_id)
    response_streamer(uri)
  end

  def letters
    letter = params[:letter]
    uri = ConstituencyQueryObject.all_by_letter(letter)
    response_streamer(uri)
  end

  def current_letters
    letter = params[:letter]
    uri = ConstituencyQueryObject.all_current_by_letter(letter)
    response_streamer(uri)
  end

  def lookup_by_letters
    letters = params[:letters]
    uri = ConstituencyQueryObject.lookup_by_letters(letters)
    response_streamer(uri)
  end
end