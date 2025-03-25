require "net/http"
require "uri"
class ChatsController < ApplicationController
  protect_from_forgery with: :exception
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
        @message_count = @chat_session.messages.count
        @score = session[:chat_score] if @message_count >= 10
      else
        @chat_logs = []
        @current_theme = nil
        @message_count = 0
        session.delete(:chat_session_id)
        session.delete(:chat_score)
      end
    else
      @chat_logs = []
      @current_theme = nil
      @message_count = 0
    end
  end

  def new
    user = current_user
    difficulty = params[:difficulty]
    theme = params[:theme]
    if difficulty.present? && theme.present?
      chat_session = ChatSession.create(user: user, difficulty: difficulty, theme: theme)
      session[:chat_session_id] = chat_session.id
      redirect_to chats_path
    else
      session[:error_message] = "テーマを選択してください"
      redirect_to homes_path
    end
  end

  def create
    message = params[:message]
    user = current_user
    chat_session_id = session[:chat_session_id]
    Rails.logger.debug "ChatsController session_id: #{session.id}"

    if chat_session_id.nil?
      return render json: { error: "チャットセッションがありません" }, status: :bad_request
    else
      chat_session = ChatSession.find(chat_session_id)
      theme = chat_session.theme
    end

    # メッセージ回数の上限を確認
    message_count = chat_session.messages.count
    if message_count >= 10
      @chat_logs = chat_session ? chat_session.messages.order(created_at: :asc).map do |message|
        gemini_response = message.ai_response
        user_log = { role: "user", content: "<p>#{message.content}</p>" }
       gemini_log = gemini_response ? { role: "gemini", content: "<p>#{gemini_response.content}</p>" } : nil
       [ user_log, gemini_log ].compact
      end.flatten : []
      @score = session[:chat_score]
      @message_count = message_count

      redirect_to scores_path and return
    end

    # ユーザーメッセージの保存
    user_message = Message.create(user: user, chat_session: chat_session, content: message)

    # 使用するチャットのURL
    uri = URI.parse("http://localhost:3001/chat")

    chat_history = chat_session.messages.order(created_at: :asc).map do |message|
      gemini_response = message.ai_response
      user_log = { role: :"user", content: message.content }
      gemini_log = gemini_response ? { role: "gemini", content: gemini_response.content } : nil
      [ user_log, gemini_log ].compact
    end.flatten

    is_last_message = chat_session.messages.count == 10 ? true : false

    if theme.present?
      response = Net::HTTP.post(uri, { message: message, theme: theme, chatHistory: chat_history.map { |chat| chat[:content] }, isLastMessage: is_last_message }.to_json, "Content-Type" => "application/json")
      Rails.logger.debug "Sent to Gemini API: #{ { message: message, theme: theme, chatHistory: chat_history.map { |chat| chat[:content] }, isLastMessage: is_last_message }.to_json }"
    else
      response = Net::HTTP.post(uri, { message: message, chatHistory: chat_history.map { |chat| chat[:content] }, isLastMessage: is_last_message }.to_json, "Content-Type" => "application/json")
      Rails.logger.debug "Sent to Gemini API: #{ { message: message, chatHistory: chat_history.map { |chat| chat[:content] }, isLastMessage: is_last_message }.to_json }"
    end

    if response.is_a?(Net::HTTPSuccess)
      gemini_data = JSON.parse(response.body)
      gemini_response = gemini_data["gemini"]
      score = gemini_data["score"]

      AiResponse.create(message: user_message, content: gemini_response)

       if is_last_message && score.present?
          score_record = Score.create(chat_session: chat_session, score: score.to_i) # スコアを保存
          session[:chat_score] = score_record.score
          Rails.logger.debug "ChatsController session[:chat_score]: #{session[:chat_score]}"
       end
    else
      Rails.logger.error "Gemini API request failes with status #{response.code}"
    end

    @chat_logs = chat_session ? chat_session.messages.order(created_at: :asc).limit(10).map do |message|
      gemini_response = message.ai_response
      user_log = { role: "user", content: "<p>#{message.content}</p>" }
      gemini_log = gemini_response ? { role: "gemini", content: "<p>#{gemini_response.content}</p>" } : nil
      [ user_log, gemini_log ].compact
    end.flatten : []

    @message_count = chat_session.messages.count

    render turbo_stream: [
    turbo_stream.update("chat-log",
      partial: "chats/chat_log",
      locals: { chat_logs: @chat_logs, message_count: @message_count }
    ),
    (chat_session.messages.count < 10 ? turbo_stream.update("chat-form", partial: "chats/chat_form") :
    turbo_stream.replace("chat-form", partial: "chats/score_link", locals: { chat_session: chat_session }))
    ]
  end
end
