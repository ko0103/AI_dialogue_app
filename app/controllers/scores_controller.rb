class ScoresController < ApplicationController
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
end
