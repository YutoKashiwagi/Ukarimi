require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET" do
    example "リクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
