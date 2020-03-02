require 'rails_helper'

RSpec.feature "Likes::Questions", type: :feature do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'ログインしていない時' do
    before { visit question_path(question.id) }

    example 'いいね(高評価)ボタンが表示されていないこと' do
      expect(page).not_to have_button '高評価'
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example 'いいねできること' do
      expect { click_button '高評価' }.to change { question.likes.count }.by(1)
      expect(page).to have_button '高評価済み'
    end

    describe 'いいねしてあるとき' do
      before { click_button '高評価' }

      example 'いいね解除できること' do
        expect { click_button '高評価済み' }.to change { question.likes.count }.by(-1)
      end
    end

    describe '高評価ボタン' do
      describe 'いいねしてない時' do
        example '切り替わること' do
          click_button '高評価'
          expect(page).to have_button '高評価済み'
        end
      end

      describe 'いいねしている時' do
        before { click_button '高評価' }

        example '切り替わること' do
          click_button '高評価済み'
          expect(page).to have_button '高評価'
        end
      end
    end
  end
end
