require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "バリデーションチェック" do
    it "バリデーションが機能するか確認" do
      message = build(:message)
      expect(message).to be_valid
      expect(message.errors).to be_empty
    end

    it "文章が長い場合" do
      message = build(:message, content: "a" * 150)
      expect(message).to be_invalid
    end
  end
end
