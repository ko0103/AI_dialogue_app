require "net/http"
require "uri"
class ChatsController < ApplicationController
  def index
    user = current_user
    chat_session_id = session[:chat_session_id]

    if chat_session_id
      @chat_session = ChatSession.find_by(id: chat_session_id)
      if @chat_session
        @chat_logs = @chat_session.messages.order(created_at: :asc).limit(10).map do |message|
        gemini_response = message.ai_response
        user_log = { role: "user", content: "<p>#{message.content}</p>" }
        gemini_log = gemini_response ? { role: "gemiini", content: "<p>#{gemini_response.content}</p>" } : nil
        [ user_log, gemini_log ].compact
        end.flatten
        @current_theme = @chat_session.theme
      else
        @chat_logs = []
        @current_theme = nil
        session.delete(:chat_session_id)
      end
    else
      @chat_logs = []
      @current_theme = nil
    end
  end

  def new
    user = current_user
    theme = params[:theme]
    if theme.present?
      chat_session = ChatSession.create(user: user, difficulty: "easy", theme: theme)
      session[:chat_session_id] = chat_session.id
      redirect_to chats_path
    else
      flash[:error] = "テーマを選択してください"
      redirect_to homes_path
    end
  end

  def create
    message = params[:message]
    user = current_user
    chat_session_id = session[:chat_session_id]

    if chat_session_id.nil?
      return render json: { error: "チャットセッションがありません" }, status: :bad_request
    else
      chat_session = ChatSession.find(chat_session_id)
      theme = chat_session.theme
    end

    # ユーザーメッセージの保存
    user_message = Message.create(user: user, chat_session: chat_session, content: message)

    uri = URI.parse("http://localhost:3001/chat")
    # response = Net::HTTP.post(uri, { message: message }.to_json, "Content-Type" => "application/json")

    if theme.present?
      response = Net::HTTP.post(uri, { message: message, theme: theme }.to_json, "Content-Type" => "application/json")
      Rails.logger.debug "Sent to Gemini API: #{ { message: message, theme: theme }.to_json }"
    else
      response = Net::HTTP.post(uri, { message: message}.to_json, "Content-Type" => "application/json")
      Rails.logger.debug "Sent to Gemini API: #{ { message: message }.to_json }"
    end

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

    # render :index, status: :unprocessable_entity
    # render json: { chat_logs: @chat_logs }, status: :ok
    render turbo_stream:
    turbo_stream.update("chat-log",
      partial: "chats/chat_log",
      locals: { chat_logs: @chat_logs }
    )
  end
end
