require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    context "ユーザー新規登録" do
      it "フォームの入力値が正常の場合、登録できる", js: true do
        visit "users/sign_up"
        fill_in "user_name", with: "らんてくん"
        fill_in "user_email", with: "test@example.com"
        fill_in "user_password", with: "runtekun"
        fill_in "user_password_confirmation", with: "runtekun"
        click_button "新規登録"
        expect(page).to have_content("アカウント登録が完了しました。", wait: 1)
        expect(current_path).to eq(homes_path)
      end

      it "メールアドレスが空の時に登録に失敗" do
        visit "users/sign_up"
        fill_in "user_name", with: "らんてくん"
        fill_in "user_email", with: ""
        fill_in "user_password", with: "runtekun"
        fill_in "user_password_confirmation", with: "runtekun"
        click_button "新規登録"
        expect(page).to have_content("1 件のエラーが発生したため ユーザー は保存されませんでした。")
        expect(page).to have_content("メールアドレスを入力してください")
        expect(current_path).to eq "/users/sign_up"
      end

      it "同一メールアドレスの時に登録失敗" do
        visit "users/sign_up"
        fill_in "user_name", with: "らんてくん"
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "runtekun"
        fill_in "user_password_confirmation", with: "runtekun"
        click_button "新規登録"
        expect(page).to have_content("1 件のエラーが発生したため ユーザー は保存されませんでした。")
        expect(page).to have_content("メールアドレスはすでに存在します")
        expect(current_path).to eq "/users/sign_up"
      end

      it "パスワード不一致で登録失敗" do
        visit "users/sign_up"
        fill_in "user_name", with: "らんてくん"
        fill_in "user_email", with: "test@sample.com"
        fill_in "user_password", with: "runtekun"
        fill_in "user_password_confirmation", with: "runte"
        click_button "新規登録"
        expect(page).to have_content("1 件のエラーが発生したため ユーザー は保存されませんでした。")
        expect(page).to have_content("パスワード（確認用）とパスワードの入力が一致しません")
        expect(current_path).to eq "/users/sign_up"
      end
    end
  end
end
