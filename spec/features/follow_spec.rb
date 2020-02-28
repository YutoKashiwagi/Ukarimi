require 'rails_helper'

RSpec.feature "Follows", type: :feature do
  include Warden::Test::Helpers

  let(:taro) { create(:user) }
  let(:jiro) { create(:user) }

  describe 'ログインしていないとき' do
    example 'フォローボタンが表示されてないこと' do
      visit user_path(taro.id)
      expect(page).not_to have_button 'フォローする'
      expect(page).not_to have_button 'フォロー解除'
    end
  end

  describe 'ログインしているとき' do
    before do
      login_as taro, scope: :user
      visit user_path(jiro.id)
    end

    example 'フォローできること' do
      click_on 'フォローする'
      expect(taro.following?(jiro)).to eq true
    end

    example 'フォロー解除できること' do
      click_on 'フォローする'
      click_on 'フォロー解除'
      expect(taro.following?(jiro)).to eq false
    end
  end
end
