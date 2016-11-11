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
end
