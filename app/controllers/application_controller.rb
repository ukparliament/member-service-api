class ApplicationController < ActionController::API
  def index
    render json: {test: MemberServiceApi::Application.config.data_endpoint }
  end
end
