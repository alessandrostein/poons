class ApplicationController < ActionController::API
  def setup
    if request['hub.verify_token'] == Rails.application.secrets.facebook_messenger['validation_token']
      render json: request['hub.challenge']
    end
  end

  def receive
    p request
    render status: 200
  end
end
