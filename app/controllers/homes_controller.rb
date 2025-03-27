class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @error_message = session.delete(:error_message)
    @difficulty = session[:difficulty] || "easy"
    @themes = generate_themes(@difficulty)
  end

  def theme_options
    @difficulty = params[:difficulty]
    session[:difficulty] = @difficulty
    @themes = generate_themes(@difficulty)
    render turbo_stream: turbo_stream.replace("theme_options", partial: "homes/theme_option", locals: { themes: @themes, difficulty: @difficulty })
  end

  private

  def generate_themes(difficulty)
    @free_theme = difficulty == "free"
    themes = case difficulty
    when "easy"
      [ "スポーツ： #{Faker::Sport.sport}", "ジブリ作品： #{Faker::JapaneseMedia::StudioGhibli.movie}" ]
    when "normal"
      [ "文学作品： #{Faker::Book.title}", "商品： #{Faker::Commerce.product_name}", "素材： #{Faker::Commerce.material}" ]
    when "hard"
      [ "色： #{Faker::Color.color_name}", "感情： #{Faker::Emotion.noun}", "惑星： #{Faker::Space.planet}" ]
    when "free"
      []
    end
    themes
  end
end
