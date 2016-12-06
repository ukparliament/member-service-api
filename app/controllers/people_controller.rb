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

  def constituencies
    person_id = params[:person_id]
    data = PersonQueryObject.constituencies(person_id)
    format(data)
  end

  def current_constituencies
    person_id = params[:person_id]
    data = PersonQueryObject.current_constituencies(person_id)
    format(data)
  end

  def parties
    person_id = params[:person_id]
    data = PersonQueryObject.parties(person_id)
    format(data)
  end

  def current_parties
    person_id = params[:person_id]
    data = PersonQueryObject.current_parties(person_id)
    format(data)
  end

  def contact_points
    person_id = params[:person_id]
    data = PersonQueryObject.contact_points(person_id)
    format(data)
  end

  def houses
    person_id = params[:person_id]
    data = PersonQueryObject.houses(person_id)
    format(data)
  end

  def letters
    letter = params[:letter]
    data = PersonQueryObject.all_by_letter(letter)
    format(data)
  end
end
