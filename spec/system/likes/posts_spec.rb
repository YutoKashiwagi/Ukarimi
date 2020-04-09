require 'rails_helper'

RSpec.describe "Likes::Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe 'ログインしていない時' do
    before { visit post_path(post.id) }

    example 'いいねボタンが表示されていないこと' do
      within(".post_#{post.id}") do
        expect(page).not_to have_selector ".like_#{post.id}"
        expect(page).not_to have_selector ".unlike_#{post.id}"
      end
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit post_path(post.id)
    end

    context 'いいねしていない時' do
      example 'いいねできること' do
        within(".post_#{post.id}") do
          expect { find(".like_#{post.id}").click }.to change { post.likes.count }.by(1)
        end
      end
    end

    context 'いいねしている時' do
      before do
        post.liked_by(user)
        visit post_path(post.id)
      end

      example 'いいね解除できること' do
        within(".post_#{post.id}") do
          expect { find(".unlike_#{post.id}").click }.to change { post.likes.count }.by(-1)
        end
      end
    end
  end
end
