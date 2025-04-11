class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_session
  has_one :ai_response, dependent: :destroy

  validates :content, length: { maximum: 140, message: "140字以内で入力してください!" }
  validates :content, presence: { message: "メッセージを入力してください!" }
end
