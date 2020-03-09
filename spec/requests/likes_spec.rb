require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  shared_examples 'like#create, destroy' do
    describe 'create' do
      context 'ログインしている時' do
        before { sign_in user }

        example '正常にいいね出来ること' do
          expect do
            post create_likes_path, params: likable_params
          end.to change { likable.likes.count }.by(1)
        end
      end

      context 'ログインしていない時' do
        before { post create_likes_path, params: likable_params }

        example 'サインイン画面へリダイレクトされること' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'destroy' do
      let!(:like) { create(:like, user: user, likable: likable) }

      context 'ログインしている時' do
        context '本人の場合' do
          before { sign_in user }

          example 'いいね解除できること' do
            expect do
              delete like_path(like.id), params: { like: { user_id: user.id } }
            end.to change { likable.likes.count }.by(-1)
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

  describe 'likable => question' do
    include_examples 'like#create, destroy' do
      let!(:likable) { create(:question, user: user) }
      let(:create_likes_path) { question_likes_path(likable.id) }
      let(:likable_params) { { question: likable } }
    end
  end

  describe 'likable => answer' do
    include_examples 'like#create, destroy' do
      let!(:likable) { create(:answer, user: user) }
      let(:create_likes_path) { answer_likes_path(likable.id) }
      let(:likable_params) { { answer: likable } }
    end
  end

  describe 'likable => post' do
    include_examples 'like#create, destroy' do
      let!(:likable) { create(:post, user: user) }
      let(:create_likes_path) { post_likes_path(likable.id) }
      let(:likable_params) { { post: likable } }
    end
  end
end
