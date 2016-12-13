class MembersController < ApplicationController
  def index
    uri = MemberQueryObject.all
    response_streamer(uri)
  end

  def current
    uri = MemberQueryObject.all_current
    response_streamer(uri)
  end

  def letters
    letter = params[:letter]
    uri = MemberQueryObject.all_by_letter(letter)
    response_streamer(uri)
  end

  def current_letters
    letter = params[:letter]
    uri = MemberQueryObject.all_current_by_letter(letter)
    response_streamer(uri)
  end
end