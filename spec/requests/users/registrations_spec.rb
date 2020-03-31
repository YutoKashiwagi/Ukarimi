require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let!(:guest) { create(:user, role: :guest) }

  describe '#update' do
    context 'ゲストユーザーとしてログインしている時' do
      before { sign_in guest }

      example 'ホーム画面へリダイレクトされること' do
        put user_registration_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    context 'ゲストユーザーとしてログインしている時' do
      before { sign_in guest }

      example 'ホーム画面へリダイレクトされること' do
        delete user_registration_path
        expect(response).to redirect_to root_path
      end
    end
  end
end
