require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let(:stock_params) { { question_id: question.id } }

  describe 'index' do
    before { get user_stocks_path(user.id) }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'create' do
    context 'ログインしている時' do
      before { sign_in user }

      example 'ストックできること' do
        expect do
          post user_stocks_path(user.id), params: { stock: stock_params }, xhr: true
        end.to change { user.stocks.count }.by(1).and change { user.active_notifications.count }.by(1)
      end
    end

    context 'ログインしていない時' do
      before { post user_stocks_path(user.id), params: { stock: stock_params } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'destroy' do
    let!(:stock) { create(:stock, user: user, question: question) }

    context 'ログインしている時' do
      before { sign_in user }

      example '正常に削除できること' do
        expect do
          delete stock_path(stock.id), params: { stock: stock_params }, xhr: true
        end.to change { user.stocks.count }.by(-1)
      end
    end

    context 'ログインしていない時' do
      before { delete stock_path(stock.id), params: { stock: stock_params } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
