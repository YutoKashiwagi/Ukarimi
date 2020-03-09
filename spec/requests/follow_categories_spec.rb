require 'rails_helper'

RSpec.describe "Category::FollowCategories", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:category) { create(:category) }

  describe 'create' do
    context 'ログインしている時' do
      before { sign_in user }

      context 'フォローしていない場合' do
        example 'フォロー出来ること' do
          expect do
            post follow_category_path, params: { category_id: category.id }
          end.to change { user.categories.count }.by(1)
        end
      end

      context 'フォローしている時' do
        before do
          user.follow_category(category)
        end

        example '再度フォロー出来ないこと' do
          expect do
            post follow_category_path, params: { category_id: category.id }
          end.not_to change { user.categories.count }
        end
      end
    end

    context 'ログインしていない場合' do
      before { post follow_category_path, params: { category_id: category.id } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'destroy' do
    context 'ログインしている時' do
      before { sign_in user }

      context 'フォローしている場合' do
        before { user.follow_category(category) }

        example 'フォロー解除できること' do
          expect do
            delete unfollow_category_path, params: { category_id: category.id }
          end.to change { user.categories.count }.by(-1)
        end
      end

      context 'フォローしていない場合' do
        example '再度フォロー解除できないこと' do
          expect do
            delete unfollow_category_path, params: { category_id: category.id }
          end.not_to change { user.categories.count }
        end
      end
    end

    context 'ログインしていない場合' do
      before { delete unfollow_category_path, params: { category_id: category.id } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
