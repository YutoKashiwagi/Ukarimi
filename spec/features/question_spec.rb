require 'rails_helper'

RSpec.feature "Questions", type: :feature do
  include Warden::Test::Helpers
  let!(:user) { create(:user) }

  describe '質問の投稿' do
    it '正常に投稿が出来ること' do
      login_as user, scope: :user
      visit questions_path
      fill_in 'Title', with: 'title'
      fill_in 'Content', with: 'content'
      expect{ click_on '投稿する' }.to change{ user.questions.count }.by(1)
    end
  end
end
