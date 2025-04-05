class ChatSession < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_one :score, dependent: :destroy

  validates :theme, length: { maximum: 30 }
end
