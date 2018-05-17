class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  def test
    render json: 'Hello World'
  end
  def institutions
    render json: Institution.all
  end
end
