require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  # モデル名はpostだが、postと名付けるとpostメソッドと被るのでtweetとする
  let!(:tweet) { create(:post, user: user) }
  let(:tweet_params) { { content: 'content', category_ids: [] } }

  describe 'index' do
    before { get posts_path }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'show' do
    before { get post_path(tweet.id) }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'create' do
    context 'ログインしている時' do
      before { sign_in user }

      example '正常に作成できること' do
        expect do
          post posts_path, params: { post: tweet_params }
        end.to change { user.posts.count }.by(1)
      end
    end

    context 'ログインしていない場合' do
      before { post posts_path, params: { post: tweet_params } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'edit' do
    context 'ログインしている時' do
      context '本人の場合' do
        before do
          sign_in user
          get edit_post_path(tweet.id)
        end

        example '200レスポンスを返すこと' do
          expect(response).to have_http_status(200)
        end
      end

      context '本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            get edit_post_path(tweet.id)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない場合' do
      before { get edit_post_path(tweet.id) }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'update' do
    context 'ログインしている時' do
      context '本人の場合' do
        before do
          sign_in user
          patch post_path(tweet.id), params: { post: tweet_params }
        end

        example '投稿一覧ページへリダイレクトされること' do
          expect(response).to redirect_to posts_path
        end
      end

      context '本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            patch post_path(tweet.id), params: { post: tweet_params }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない場合' do
      before { patch post_path(tweet.id), params: { post: tweet_params } }

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
            delete post_path(tweet.id)
          end.to change { user.posts.count }.by(-1)
        end
      end

      context '本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            delete post_path(tweet.id)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない場合' do
      before { delete post_path(tweet.id) }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
