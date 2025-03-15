class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # validates :name, presence: true
  has_many :chat_sessions
  has_many :messages

  def self.from_omniauth(auth)
    data = auth.info
    user = User.where(email: data["email"]).first

    unless user
      user = User.create(
        name: data["name"],
        email: data["email"],
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end
