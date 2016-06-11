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
    p "Entrou"
    p "Requisição: #{request}"
    message = request["entry"][0]["messaging"][0]["message"]["text"]
    p "Mensagem: #{message}"
    user_id = request["entry"][0]["messaging"][0]["recipient"]["id"]
    p "Usuário: #{user_id}"

    # p message
    # p user_id
    send_message(user_id, message)
    # render status: 200
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
