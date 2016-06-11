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
        p "chegou aqui"
        p "Request: #{message}"
        user_id = message["sender"]["id"]
        message_text = message["message"]["text"].present? message["message"]["text"] : "Teste"
        p "Texto para responder: #{message_text}"
        send_message(user_id, message_text)
      end
    end
  end

  def send_message(user_id, message)
    begin
      p "Mensagem recebida de #{user_id} com a mensagem #{message}"
      metadata = {
        recipient: { id: user_id },
        message: { text: "Resposta: #{message}" }
      }
      # RestClient.post(URI_SEND_FACEBOOK_MESSAGE, {:recipient => {:id => user_id}, :message => message})
      RestClient.post(URI_SEND_FACEBOOK_MESSAGE, metadata, content_type: :json, accept: :json)
      p "Mensagem respondida para #{user_id} com a mensagem Resposta: #{message}"
    rescue => e
      p "Deu erro: #{e}"
    end
  end
end
