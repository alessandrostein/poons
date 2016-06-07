class ApplicationController < ActionController::API
  def setup
    if request['hub.verify_token'] == Rails.application.secrets.facebook_messenger['validation_token']
      render json: request['hub.challenge']
    end
  end

  def receive
    message = request["entry"][0]["messaging"][0]["message"]["text"]
    user_id = request["entry"][0]["messaging"][0]["recipient"]["id"]

    p message
    p user_id

    render status: 200
  end

  def send_message(user_id, message)

  end
end
