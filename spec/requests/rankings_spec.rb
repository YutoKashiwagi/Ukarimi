require 'rails_helper'

RSpec.describe "Rankings", type: :request do
  describe 'get' do
    before { get rankings_path }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end
end
