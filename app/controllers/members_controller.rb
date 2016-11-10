class MembersController < ApplicationController
  def index
    data = MemberQueryObject.all
    format(data)
  end

  def current
    data = MemberQueryObject.all_current
    format(data)
  end
end