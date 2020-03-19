require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  shared_examples 'comment#create, destroy' do
    let!(:comment) { create(:comment, commentable: commentable) }
    describe 'create' do
      context 'ログインしている時' do
        before { sign_in user }

        example '正常に作成できること' do
          expect do
            post create_comment_path, params: { comment: { user_id: user.id, content: 'content' } }
          end.to change { commentable.comments.count }.by(1).and change(Notification, :count).by(1)
        end
      end

      context 'ログインしていない時' do
        before { post create_comment_path, params: { comment: { user_id: user.id, content: 'content' } } }

        example 'サインイン画面へリダイレクトされること' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'destroy' do
      let!(:comment) { create(:comment, user: user, commentable: commentable) }

      context 'ログインしている時' do
        context '本人の場合' do
          before { sign_in user }

          example '正常に削除できること' do
            expect do
              delete comment_path(comment.id)
            end.to change { commentable.comments.count }.by(-1)
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

  describe 'commentable => question' do
    include_examples 'comment#create, destroy' do
      let(:commentable) { create(:question, user: user) }
      let(:create_comment_path) { question_comments_path(commentable.id) }
    end
  end

  describe 'commentable => answer' do
    include_examples 'comment#create, destroy' do
      let(:commentable) { create(:answer, user: user) }
      let(:create_comment_path) { answer_comments_path(commentable.id) }
    end
  end

  describe 'commentable => post' do
    include_examples 'comment#create, destroy' do
      let(:commentable) { create(:post, user: user) }
      let(:create_comment_path) { post_comments_path(commentable.id) }
    end
  end
end
