module LoginMacros
  def login(user)
    visit "users/sign_in"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "ログイン"
    expect(page).to have_content("ログインしました。")
    expect(current_path).to eq homes_path
  end
end
