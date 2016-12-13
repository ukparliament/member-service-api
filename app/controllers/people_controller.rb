require 'net/http'
require 'uri'

class PeopleController < ApplicationController
  def index
    uri = PersonQueryObject.all
    response_streamer(uri)
  end

  def show
    id = params[:id]
    uri = PersonQueryObject.find(id)
    response_streamer(uri)
  end

  def constituencies
    person_id = params[:person_id]
    uri = PersonQueryObject.constituencies(person_id)
    response_streamer(uri)
  end

  def current_constituencies
    person_id = params[:person_id]
    uri = PersonQueryObject.current_constituencies(person_id)
    response_streamer(uri)
  end

  def parties
    person_id = params[:person_id]
    uri = PersonQueryObject.parties(person_id)
    response_streamer(uri)
  end

  def current_parties
    person_id = params[:person_id]
    uri = PersonQueryObject.current_parties(person_id)
    response_streamer(uri)
  end

  def contact_points
    person_id = params[:person_id]
    uri = PersonQueryObject.contact_points(person_id)
    response_streamer(uri)
  end

  def houses
    person_id = params[:person_id]
    uri = PersonQueryObject.houses(person_id)
    response_streamer(uri)
  end

  def letters
    letter = params[:letter]
    uri = PersonQueryObject.all_by_letter(letter)
    response_streamer(uri)
  end

  def sittings
    person_id = params[:person_id]
    uri = PersonQueryObject.sittings(person_id)
    response_streamer(uri)
  end
end
