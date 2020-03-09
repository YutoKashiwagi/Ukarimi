require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'commetable => question' do
    let!(:comment) { create(:comment, user: user, commentable: question) }

    describe 'create' do
      context 'ログインしている時' do
        before { sign_in user }
        example '正常に作成できること' do
          expect do
            post question_comments_path(question.id), params: { comment: { user_id: user.id, content: 'content' } }
          end.to change { question.comments.count }.by(1)
        end
      end

      context 'ログインしていない時' do
        before { post question_comments_path(question.id), params: { comment: { user_id: user.id, content: 'content' } } }
        example 'サインイン画面へリダイレクトされること' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'destroy' do
      context 'ログインしている時' do
        context '本人の場合' do
          before { sign_in user }
          example '正常に削除できること' do
            expect do
              delete comment_path(comment.id)
            end.to change { question.comments.count }.by(-1)
          end
        end

        context '本人でない場合' do
          before { sign_in other_user }
          example 'エラーが発生すること' do
            expect do
              delete comment_path(comment.id)
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context 'ログインしていない時' do
        before { delete comment_path(comment.id) }
        example 'サインイン画面へリダイレクトされること' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
