class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable, :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # validates :name, presence: true
  has_many :chat_sessions
  has_many :messages
end
