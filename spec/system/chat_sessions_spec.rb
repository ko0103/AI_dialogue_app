require 'rails_helper'

RSpec.describe "ChatSessions", type: :system do
  include LoginMacros
  let(:user) { create(:user) }

  describe "チャット開始まで" do
    it "フリーテーマ以外のいずれかの難易度とテーマを選択している場合、チャット画面に遷移" do
      login(user)
      difficulties = [ "初級", "中級", "上級" ]
      selected_difficulties = difficulties.sample
      click_link (selected_difficulties)
      click_button "対話開始"
      expect(page).to have_content("まだメッセージはありません")
    end

    it "フリーテーマを選択してかつテーマを決めてチャットが開始される" do
      login(user)
      click_link "フリーテーマ"
      fill_in "theme", with: "テスト"
      click_button "対話開始"
      expect(page).to have_content("まだメッセージはありません")
    end

    it "フリーテーマを選択してかつテーマを決めずにチャット開始すると失敗" do
      login(user)
      click_link "フリーテーマ"
      fill_in "theme", with: ""
      click_button "対話開始"
      expect(page).to have_content("テーマを選択してください")
    end
  end
end
