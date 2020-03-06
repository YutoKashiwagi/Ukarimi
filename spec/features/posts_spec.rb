require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  include Warden::Test::Helpers
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }

  before do
    login_as user, scope: :user
    visit user_posts_path(user.id)
  end

  describe 'create' do
    context '正常値' do
      before { fill_in 'post[content]', with: 'こんにちは' }

      example '正常に投稿できること' do
        check category.name
        expect { click_button '投稿する' }.to change { user.posts.count }.by(1)
        within(".post_#{Post.last.id}") do
          expect(page).to have_content Post.last.content
          expect(page).to have_content category.name
        end
      end

      example 'タグなしでも投稿できること' do
        expect { click_button '投稿する' }.to change { user.posts.count }.by(1)
      end
    end
  end

  describe 'update' do
    let!(:post) { create(:post, user: user) }

    before { visit edit_post_path(post.id) }

    example '編集できること' do
      fill_in 'post[content]', with: '編集後'
      click_button '編集'
      expect(page).to have_content '編集後'
    end
  end

  describe 'destory' do
    let!(:post) { create(:post, user: user) }

    before { visit user_posts_path(user.id) }

    example '削除できること' do
      expect { click_link '削除' }.to change { user.posts.count }.by(-1)
    end
  end
end
