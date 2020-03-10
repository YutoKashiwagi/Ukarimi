require 'rails_helper'

RSpec.describe "Likes::Posts", type: :system do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe 'ログインしていない時' do
    before { visit user_posts_path(user.id) }

    example 'いいねボタンが表示されていないこと' do
      expect(page).not_to have_button 'いいね'
      expect(page).not_to have_button 'いいね済'
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit user_posts_path(user.id)
    end

    context 'いいねしていない時' do
      example 'いいねできること' do
        within(".post_#{post.id}") do
          expect { click_button 'いいね' }.to change { post.likes.count }.by(1)
        end
      end
    end

    context 'いいねしている時' do
      before { click_button 'いいね' }

      example 'いいね解除できること' do
        within(".post_#{post.id}") do
          expect { click_button 'いいね済' }.to change { post.likes.count }.by(-1)
        end
      end
    end
  end
end
