require 'rails_helper'

RSpec.describe "Likes::Answers", type: :system do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'ログインしていない時' do
    before { visit question_path(question.id) }

    example 'いいね(高評価)ボタンが表示されていないこと' do
      within('.answer_container') { expect(page).not_to have_button '高評価' }
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example 'いいねできること' do
      within('.answer_container') do
        expect { click_button '高評価' }.to change { answer.likes.count }.by(1)
      end
    end

    describe 'いいねしてあるとき' do
      before { within('.answer_container') { click_button '高評価' } }

      example 'いいね解除できること' do
        within('.answer_container') do
          expect { click_button '高評価済み' }.to change { answer.likes.count }.by(-1)
        end
      end
    end

    describe '高評価ボタン' do
      describe 'いいねしてない時' do
        before { within('.answer_container') { click_button '高評価' } }

        example '切り替わること' do
          within('.answer_container') do
            expect(page).to have_button '高評価済み'
          end
        end
      end

      describe 'いいねしている時' do
        before { within('.answer_container') { click_button '高評価' } }

        example '切り替わること' do
          within('.answer_container') do
            click_button '高評価済み'
            expect(page).to have_button '高評価'
          end
        end
      end
    end
  end
end
