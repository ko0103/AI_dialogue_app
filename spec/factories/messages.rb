FactoryBot.define do
  factory :chat_session do
    association :user
    difficulty { "easy" }
    theme { "ランテック" }
  end

  factory :message do
    association :user
    association :chat_session
    content { "こんにちは" }
  end
end
