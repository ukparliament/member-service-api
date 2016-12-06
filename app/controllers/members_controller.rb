class MembersController < ApplicationController
  def index
    data = MemberQueryObject.all
    format(data)
  end

  def current
    data = MemberQueryObject.all_current
    format(data)
  end

  def letters
    letter = params[:letter]
    data = MemberQueryObject.all_by_letter(letter)
    format(data)
  end

  def current_letters
    letter = params[:letter]
    data = MemberQueryObject.all_current_by_letter(letter)
    format(data)
  end
end