require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe '#new_guest' do
    context 'session[:user_return_to]が存在しているとき' do
      before do
        get questions_path
        post users_guest_sign_in_path
      end

      example 'フレンドリーフォワーディングされること' do
        expect(response).to redirect_to questions_path
      end
    end
  end
end
