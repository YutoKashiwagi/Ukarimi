require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'question' do
    let!(:question) { create(:question) }

    describe 'create' do
      context 'ログインしている時' do
        before { sign_in user }

        example '正常にいいね出来ること' do
          expect do
            post question_likes_path(question.id), params: { question: question }
          end.to change { question.likes.count }.by(1)
        end
      end

      context 'ログインしていない時' do
        before { post question_likes_path(question.id), params: { question: question } }

        example 'サインイン画面へリダイレクトされること' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'destroy' do
      let!(:like) { create(:like, user: user, likable: question) }

      context 'ログインしている時' do
        context '本人の場合' do
          before { sign_in user }

          example 'いいね解除できること' do
            expect do
              delete like_path(like.id), params: { like: { user_id: user.id } }
            end.to change { question.likes.count }.by(-1)
          end
        end

        context '本人でない場合' do
          before { sign_in other_user }

          example 'エラーが発生すること' do
            expect do
              delete like_path(like.id), params: { like: { user_id: user.id } }
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context 'ログインしていない時' do
        before { delete like_path(like.id), params: { like: { user_id: user.id } } }

        example 'サインイン画面へリダイレクトされること' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
