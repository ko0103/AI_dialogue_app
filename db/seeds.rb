# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
def create_users
  @users = []
  10.times do
    user = User.create!(
      email: Faker::Internet.email,
      name: Faker::Name.last_name,
      password: "testdata",
      password_confirmation: "testdata"
    )
    @users << user
  end
  @users
end

def create_session_and_score(users)
  users.each do |user|
    chat_session_easy = ChatSession.create!(
      user_id: user.id,
      difficulty: "easy",
      theme: "スポーツ： #{Faker::Sport.sport}"
    )
    Score.create!(
      chat_session_id: chat_session_easy.id,
      score: rand(90)
    )

    chat_session_normal = ChatSession.create!(
      user_id: user.id,
      difficulty: "normal",
      theme: "素材： #{Faker::Commerce.material}"
    )
    Score.create!(
      chat_session_id: chat_session_normal.id,
      score: rand(90)
    )

    chat_session_hard = ChatSession.create!(
      user_id: user.id,
      difficulty: "hard",
      theme: "感情： #{Faker::Emotion.noun}"
    )
    Score.create!(
      chat_session_id: chat_session_hard.id,
      score: rand(90)
    )

    chat_session_free = ChatSession.create!(
      user_id: user.id,
      difficulty: "free",
      theme: Faker::Space.galaxy
    )
    Score.create!(
      chat_session_id: chat_session_free.id,
      score: rand(90)
    )
  end
end

users = create_users
create_session_and_score(users)
