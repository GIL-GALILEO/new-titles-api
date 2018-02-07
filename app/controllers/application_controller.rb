class ApplicationController < ActionController::API
  def test
    render json: 'Hello World'
  end
  def institutions
    render json: Institution.all
  end
end
