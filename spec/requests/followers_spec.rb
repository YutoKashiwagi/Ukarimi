require 'rails_helper'

RSpec.describe "Followers", type: :request do
  let!(:user) { create(:user) }

  describe 'index' do
    before { get user_followers_path(user.id) }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end
end
