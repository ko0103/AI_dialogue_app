class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_session
  has_one :ai_response, dependent: :destroy
end
