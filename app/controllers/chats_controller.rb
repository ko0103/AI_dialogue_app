require "net/http"
require "uri"
class ChatsController < ApplicationController
  def index
    user = current_user
    @chat_session = user.chat_sessions.order(created_at: :desc).first

    if @chat_session
      @chat_logs = @chat_session.messages.order(created_at: :asc).limit(10).map do |message|
        gemini_response = message.ai_response
        user_log = { role: "user", content: "<p>#{message.content}</p>" }
        gemini_log = gemini_response ? { role: "gemiini", content: "<p>#{gemini_response.content}</p>" } : nil
        [ user_log, gemini_log ].compact
      end.flatten
    else
      @chat_logs = []
    end
  end

  def create
    message = params[:message]
    user = current_user
    chat_session_id = session[:chat_ssesion_id]

    if chat_session_id.nil?
      chat_session = ChatSession.create(user: user, difficulty: "easy", theme: "general")
      chat_session_id = chat_session.id
      session[:chat_session_id] = chat_session_id
    else
      chat_session = ChatSession.find(chat_session_id)
    end

    # ユーザーメッセージの保存
    user_message = Message.create(user: user, chat_session: chat_session, content: message)

    uri = URI.parse("http://localhost:3001/chat")
    response = Net::HTTP.post(uri, { message: message }.to_json, "Content-Type" => "application/json")

    if response.is_a?(Net::HTTPSuccess)
      gemini_response = JSON.parse(response.body)["gemini"]
      AiResponse.create(message: user_message, content: gemini_response)
    else
      Rails.logger.error "Gemini API request failes with status #{response.code}"
    end

    @chat_logs = chat_session ? chat_session.messages.order(created_at: :asc).limit(10).map do |message|
      gemini_response = message.ai_response
      user_log = { role: "user", content: "<p>#{message.content}</p>" }
      gemini_log = gemini_response ? { role: "gemini", content: "<p>#{gemini_response.content}</p>" } : nil
      [ user_log, gemini_log ].compact
    end.flatten : []

    render :index, status: :unprocessable_entity
  end
end
