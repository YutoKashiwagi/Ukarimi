require 'rails_helper'

RSpec.describe "Users::SignIns", type: :system do
  let!(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
  end

  describe '正常値' do
    example '正常にサインインできること' do
      click_button 'ログイン'
      expect(page).to have_content 'ログインしました。'
    end
  end

  describe '組み合わせが正しくない場合' do
    example 'ログインできないこと' do
      fill_in 'メールアドレス', with: 'failure@failure.com'
      click_button 'ログイン'
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end
  end

  describe 'ゲストユーザーログイン' do
    example 'ゲストユーザーとしてログインできること' do
      click_link 'ゲストログイン'
      expect(page).to have_content 'ゲストユーザーとしてログインしました'
    end
  end
end
