require 'rails_helper'

RSpec.describe "Category::Categories", type: :request do
  let!(:category) { create(:category) }

  describe 'index' do
    before { get category_categories_path(category.id) }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'show' do
    before { get category_category_path(category.id) }

    example '200レスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end
end
