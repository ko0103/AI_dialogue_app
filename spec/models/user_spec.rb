require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェックなど" do
    it "名前が空の時は無効" do
      user = build(:user, name: "")
      expect(user).to be_invalid
    end

    it "名前が長すぎる場合は無効" do
      user = build(:user, name: "a" * 70)
      expect(user).to be_invalid
    end

    it "バリデーションが機能するか確認" do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
  end
end
