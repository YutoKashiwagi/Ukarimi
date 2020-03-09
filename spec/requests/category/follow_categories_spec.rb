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
            post category_category_follow_categories_path(category.id)
          end.to change { user.categories.count }.by(1)
        end
      end

      context 'フォローしている時' do
        before do
          user.follow_category(category)
        end

        example '再度フォロー出来ないこと' do
          expect do
            post category_category_follow_categories_path(category.id)
          end.not_to change { user.categories.count }
        end
      end
    end

    context 'ログインしていない場合' do
      before { post category_category_follow_categories_path(category.id) }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'destroy' do
    context 'ログインしている時' do
      before { sign_in user }

      context 'フォローしていない場合' do
        xexample 'フォロー解除できないこと' do
        end
      end

      context 'フォローしている時' do
        before { user.follow_category(category) }

        example 'フォロー解除できること' do
          expect do
            delete category_category_follow_category_path(category_id: category.id, id: user.tag_relationships.last.id)
          end.to change { user.categories.count }.by(-1)
        end
      end
    end

    context 'ログインしていない場合' do
    end
  end
end
