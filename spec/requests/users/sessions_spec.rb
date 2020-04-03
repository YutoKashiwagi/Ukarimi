require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe '#new_guest' do
    example 'リダイレクトされること' do
      post users_guest_sign_in_path
      expect(response).to redirect_to root_path
    end
  end
end
