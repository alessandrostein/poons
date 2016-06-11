require 'net/http'
require 'net/https'
class ApplicationController < ActionController::API

  URI_SEND_FACEBOOK_MESSAGE = "https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets.facebook_messenger['validation_token']}"

  def setup
    if request['hub.verify_token'] == Rails.application.secrets.facebook_messenger['validation_token']
      render json: request['hub.challenge']
    end
  end

  def receive
    message = request["entry"][0]["messaging"][0]["message"]["text"]
    user_id = request["entry"][0]["messaging"][0]["recipient"]["id"]

    # p message
    # p user_id
    send_message(user_id, message)
    # render status: 200
  end

  def send_message(user_id, message)
    begin
      # RestClient.post(URI_SEND_FACEBOOK_MESSAGE, {:recipient => {:id => user_id}, :message => message})
      p RestClient.post(URI_SEND_FACEBOOK_MESSAGE, {
      recipient: {id: user_id},
      message: message
    }.to_json, content_type: :json, accept: :json)
    rescue => e
      p "Deu erro: #{e}"
    end
  end
end

# RestClient.post("https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets.facebook_messenger['validation_token']}", {
#       recipient: {id: 1069123499833828},
#       message: "Ops"
#     }.to_json, content_type: :json, accept: :json)
