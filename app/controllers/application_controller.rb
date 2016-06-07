class ApplicationController < ActionController::API
  def webhook
    if request['hub.verify_token'] == Rails.application.secrets.facebook_messenger['validation_token']
      request['hub.challenge']
    end
  end
end
