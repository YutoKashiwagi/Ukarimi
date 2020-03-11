require 'rails_helper'

RSpec.describe "Stocks", type: :system do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'ログインしているとき' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example 'ストックできること' do
      expect { click_button 'ストック' }.to change { user.stocked_questions.count }.by(1)
    end

    example 'ストックを解除できること' do
      user.stock(question)
      visit question_path(question.id)
      expect { click_button 'ストック済み' }.to change { user.stocked_questions.count }.by(-1)
    end
  end

  describe 'ログインしていないとき' do
    example 'ストックできないこと' do
      visit question_path(question.id)
      expect(page).not_to have_button 'ストック'
      expect(page).not_to have_button 'ストック済み'
    end
  end
end
