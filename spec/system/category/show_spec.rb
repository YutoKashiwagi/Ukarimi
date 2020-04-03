require 'rails_helper'

RSpec.describe "Category::Shows", type: :system do
  let!(:user) { create(:user) }
  let!(:category) { create(:category, name: 'category') }

  before { login_as user, scope: :user }

  describe 'フォローボタン' do
    describe 'フォローしていないとき' do
      before { visit category_category_path(category.id) }

      example 'フォローできること' do
        expect { click_button 'フォローする' }.to change { user.categories.count }.by(1)
        expect(page).to have_button 'フォロー解除'
      end
    end

    describe 'フォローしている時' do
      before do
        user.follow_category(category)
        visit category_category_path(category.id)
      end

      example 'フォロー解除できること' do
        expect { click_button 'フォロー解除' }.to change { user.categories.count }.by(-1)
        expect(page).to have_button 'フォローする'
      end
    end
  end
end
