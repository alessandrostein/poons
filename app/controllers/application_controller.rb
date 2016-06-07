class ApplicationController < ActionController::API
  def setup
    if request['hub.verify_token'] == Rails.application.secrets.facebook_messenger['validation_token']
      render json: request['hub.challenge']
    end
  end

  def receive
    p "Chegou callback"
    messaging_events = req.body.entry[0].messaging;
    p "Carregou eventos"
    p messaging_events
    render status: 200
  end
end
