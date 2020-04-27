require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let!(:user) { create(:user) }

  shared_examples 'ホーム画面へリダイレクトされること' do
    example 'ホーム画面へリダイレクトされること' do
      expect(response).to redirect_to root_path
    end
  end

  describe '#index' do
    context 'ログインしていない場合' do
      before { get admin_users_path }

      include_examples 'ホーム画面へリダイレクトされること'
    end

    context 'ログインしている場合' do
      before { sign_in user }

      context '管理者でない場合' do
        before { get admin_users_path }

        include_examples 'ホーム画面へリダイレクトされること'
      end

      context '管理者の場合' do
        before do
          user.role = 1
          get admin_users_path
        end

        example '200レスポンスを返すこと' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe '#destroy' do
    context 'ログインしていない場合' do
      before { delete admin_user_path(user.id) }

      include_examples 'ホーム画面へリダイレクトされること'
    end

    context 'ログインしている場合' do
      before { sign_in user }

      context '管理者でない場合' do
        before { delete admin_user_path(user.id) }

        include_examples 'ホーム画面へリダイレクトされること'
      end

      context '管理者の場合' do
        before { user.role = 1 }

        example 'ユーザーを削除できること' do
          expect do
            delete admin_user_path(user.id)
          end.to change(User, :count).by(-1)
        end
      end
    end
  end
end
