require 'net/http'
require 'uri'

class PeopleController < ApplicationController
  def index
    uri = PersonQueryObject.all
    response_streamer(uri)
  end

  def lookup
    source = params['source']
    id = params['id']
    uri = PersonQueryObject.lookup(source, id)
    response_streamer(uri)
  end

  def a_z_letters
    uri = PersonQueryObject.a_z_letters
    response_streamer(uri)
  end

  def show
    id = params[:person]
    uri = PersonQueryObject.find(id)
    response_streamer(uri)
  end

  def constituencies
    person_id = params[:person_id]
    uri = PersonQueryObject.constituencies(person_id)
    response_streamer(uri)
  end

  def current_constituency
    person_id = params[:person_id]
    uri = PersonQueryObject.current_constituency(person_id)
    response_streamer(uri)
  end

  def parties
    person_id = params[:person_id]
    uri = PersonQueryObject.parties(person_id)
    response_streamer(uri)
  end

  def current_party
    person_id = params[:person_id]
    uri = PersonQueryObject.current_party(person_id)
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

  def current_house
    person_id = params[:person_id]
    uri = PersonQueryObject.current_house(person_id)
    response_streamer(uri)
  end

  def letters
    letter = params[:letter]
    uri = PersonQueryObject.all_by_letter(letter)
    response_streamer(uri)
  end

  def lookup_by_letters
    letters = params[:letters]
    uri = PersonQueryObject.lookup_by_letters(letters)
    response_streamer(uri)
  end
end
