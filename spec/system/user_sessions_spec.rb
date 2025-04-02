require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:user) { create(:user) }

  describe "ログイン前" do
    context "ログインについて" do
      before do
        visit "users/sign_in"
      end

      it "正常にログインできる場合" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "ログイン"
        expect(page).to have_content("ログインしました。")
        expect(current_path).to eq homes_path
      end

      it "メールアドレスが一致せずログインに失敗" do
        fill_in "user_email", with: "example@example.com"
        fill_in "user_password", with: user.password
        click_button "ログイン"
        expect(page).to have_content("メールアドレスまたはパスワードが違います。")
        expect(current_path).to eq "/users/sign_in"
      end

      it "パスワード不一致でログイン失敗" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "password"
        click_button "ログイン"
        expect(page).to have_content("メールアドレスまたはパスワードが違います。")
        expect(current_path).to eq "/users/sign_in"
      end
    end
  end

  describe "ログイン後" do
    context "ログアウトについて" do
      it "正常にログアウトできる", js: true do
        visit "users/sign_in"
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "ログイン"
        expect(page).to have_content("ログインしました。")
        expect(current_path).to eq homes_path
        click_link "ログアウト"
        expect(page).to have_content("ログアウトしました。")
      end
    end
  end
end
