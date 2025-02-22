class ScoresController < ApplicationController
  def index
    @easy_scores = sort_scores("easy")
    @normal_scores = sort_scores("normal")
    @hard_scores = sort_scores("hard")
    @free_scores = sort_scores("free")
  end

  def show
    chat_session_id = session[:chat_session_id]
    Rails.logger.debug "ScoresController session_id: #{session.id}"
    if chat_session_id
      @chat_session = ChatSession.find_by(id: chat_session_id)
      if @chat_session
        @score = session[:chat_score]
      else
        flash[:error] = "チャットセッションが見つかりません"
        redirect_to homes_path and return
      end
    else
      flash[:error] = "チャットセッションが見つかりません"
      redirect_to homes_path and return
    end
  end

  private

  def sort_scores(difficulty)
    ChatSession.where(difficulty: difficulty).joins(:score, :user).order("scores.score DESC").limit(10).select("chat_sessions.*, scores.score AS score_display, users.name AS user_name")
  end
end
