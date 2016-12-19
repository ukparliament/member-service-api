class ApplicationController < ActionController::API
  include ResponseStreamHelper
  def index
    render json: {test: DATA_ENDPOINT }
  end
end
