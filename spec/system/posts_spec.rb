require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let(:post) { build(:post, user: user) }

  before do
    login_as user, scope: :user
    visit new_post_path
  end

  describe 'create' do
    context '正常値' do
      before { fill_in 'post[content]', with: 'こんにちは' }

      example '正常に投稿できること' do
        check category.name
        expect { click_button 'つぶやく' }.to change { user.posts.count }.by(1)
        within(".post_#{Post.last.id}") do
          expect(page).to have_content Post.last.content
          expect(page).to have_content category.name
        end
      end

      example 'タグなしでも投稿できること' do
        expect { click_button 'つぶやく' }.to change { user.posts.count }.by(1)
      end
    end

    context '異常値' do
      context '空白の場合' do
        example '投稿できず、エラーメッセージが表示されること' do
          expect { click_button 'つぶやく' }.to change { user.posts.count }.by(0)
          expect(page).to have_content '内容を入力してください'
        end
      end

      context '文字数オーバーの場合' do
        example '投稿できず、エラーメッセージが表示されること' do
          fill_in 'post[content]', with: 'a' * 1001
          expect { click_button 'つぶやく' }.to change { user.posts.count }.by(0)
          expect(page).to have_content "内容は1000文字以内で入力してください"
        end
      end
    end
  end

  describe 'update' do
    before do
      post.save
      visit edit_post_path(post.id)
    end

    example '編集できること' do
      fill_in 'post[content]', with: '編集後'
      click_button '編集'
      expect(page).to have_content '編集後'
    end
  end

  describe 'destory' do
    before do
      post.save
      visit post_path(post.id)
    end

    example '削除できること' do
      expect { find('.delete_post').click }.to change { user.posts.count }.by(-1)
    end

    describe '本人でない場合' do
      let(:other_user) { create(:user) }

      before do
        login_as other_user, scope: :user
        post.save
        visit post_path(post.id)
      end

      example '削除ボタンが表示されていないこと' do
        expect(page).not_to have_selector '.delete_post'
      end
    end
  end
end
