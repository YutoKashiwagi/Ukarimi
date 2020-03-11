require 'rails_helper'

RSpec.describe "SignUps", type: :system do
  example '正常にサインアップできること' do
    visit new_user_registration_path
    fill_in 'Name', with: 'foobar'
    fill_in 'メールアドレス', with: 'foobar@foobar.com'
    fill_in 'パスワード', with: 'foobar'
    fill_in '確認用パスワード', with: 'foobar'
    click_button 'アカウント登録'
    expect(page).to have_content 'foobar'
  end
end
