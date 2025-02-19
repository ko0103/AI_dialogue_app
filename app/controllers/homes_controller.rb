class HomesController < ApplicationController
  def index
    @difficulty = params[:difficulty] || "easy"
    @themes = generate_themes(@difficulty)
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("theme_options", partial: "homes/theme_option", locals: { themes: @themes}) }
    end
  end

  private

  def generate_themes(difficulty)
    @free_theme = difficulty == "free"
    themes = case @difficulty
    when "easy"
      [Faker::Sport.sport, Faker::JapaneseMedia::StudioGhibli.movie]
    when "normal"
      [Faker::Book.title, Faker::Commerce.department]
    when "hard"
      [Faker::Color.color_name, Faker::Emotion.noun, Faker::Space.planet]
    when "free"
      []
    end
    themes
  end
end
