require 'rails_helper'

RSpec.describe "Followees", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'index' do
    before { get user_followees_path(user.id) }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'create' do
    context 'ログインしている時' do
      before { sign_in user }

      context 'フォローしていない場合' do
        example 'フォローできること' do
          expect do
            post user_followees_path(other_user.id), params: { user_id: other_user.id }
          end.to change { user.followees.count }.by(1)
        end
      end

      context '既にフォローしている場合' do
        before { user.follow other_user }

        example 'フォローできないこと' do
          expect do
            post user_followees_path(other_user.id), params: { user_id: other_user.id }
          end.to change { user.followees.count }.by(0)
        end
      end
    end

    context 'ログインしていない時' do
      before { post user_followees_path(other_user.id), params: { user_id: other_user.id } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'destroy' do
    context 'ログインしている時' do
      before { sign_in user }

      context '既にフォローしている時' do
        before { user.follow other_user }

        example 'フォロー解除できること' do
          expect do
            delete followee_path(other_user.id), params: { user_id: other_user.id }
          end.to change { user.followees.count }.by(-1)
        end
      end

      context 'フォローしていない場合' do
        example 'フォロー解除できないこと' do
          expect do
            delete followee_path(other_user.id), params: { user_id: other_user.id }
          end.to change { user.followees.count }.by(0)
        end
      end
    end

    context 'ログインしていない時' do
      before { delete followee_path(other_user.id), params: { user_id: other_user.id } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
