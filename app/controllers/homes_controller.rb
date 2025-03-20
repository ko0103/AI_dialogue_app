class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @error_message = session.delete(:error_message)
    @difficulty = params[:difficulty] || "easy"
    @themes = generate_themes(@difficulty)
  end

  def theme_options
    @difficulty = params[:difficulty] || "easy"
    @themes = generate_themes(@difficulty)
    render turbo_stream: turbo_stream.replace("theme_options", partial: "homes/theme_option", locals: { themes: @themes, difficulty: @difficulty })
  end

  private

  def generate_themes(difficulty)
    @free_theme = difficulty == "free"
    themes = case difficulty
    when "easy"
      [ Faker::Sport.sport, Faker::JapaneseMedia::StudioGhibli.movie ]
    when "normal"
      [ Faker::Book.title, Faker::Commerce.department ]
    when "hard"
      [ Faker::Color.color_name, Faker::Emotion.noun, Faker::Space.planet ]
    when "free"
      []
    end
    themes
  end
end
