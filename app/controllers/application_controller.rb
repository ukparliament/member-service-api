class ApplicationController < ActionController::API
  include FormatHelper
  include ActionController::MimeResponds
  def index
    render json: {test: DATA_ENDPOINT }
  end
end
