require 'net/http'
require 'net/https'
class ApplicationController < ActionController::API

  URI_SEND_FACEBOOK_MESSAGE = "https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets.facebook_messenger['validation_token']}"

  def setup
    if request['hub.verify_token'] == Rails.application.secrets.facebook_messenger['verify_token']
      render json: request['hub.challenge']
    end
  end

  def receive
    entry_received = request["entry"]
    entry_received.each do |entry|
      messaging_received = entry["messaging"]
      messaging_received.each do |message|
        user_id = message["sender"]["id"] if message["sender"].present? && message["sender"]["id"].present?
        message_text = message["message"]["text"] if message["message"].present? && message["message"]["text"].present?
        send_message(user_id, message_text) if user_id.present? && message_text.present?
      end
    end
  end

  def send_message(user_id, message)
    begin
      metadata = {
        recipient: { id: user_id },
        message: { text: "Resposta: #{message}" }
      }
      RestClient.post(URI_SEND_FACEBOOK_MESSAGE, metadata, content_type: :json, accept: :json)
    rescue => e
      p e
    end
  end
end
