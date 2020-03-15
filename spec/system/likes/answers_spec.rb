require 'rails_helper'

RSpec.describe "Likes::Answers", type: :system do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'ログインしていない時' do
    before { visit question_path(question.id) }

    example 'いいねボタンが表示されていないこと' do
      within(".answer_container") do
        expect(page).not_to have_selector ".like_#{answer.id}"
        expect(page).not_to have_selector ".unlike_#{answer.id}"
      end
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example 'いいねできること' do
      within('.answer_container') do
        expect { find(".like_#{answer.id}").click }.to change { answer.likes.count }.by(1)
      end
    end

    describe 'いいねしてあるとき' do
      before { within('.answer_container') { find(".like_#{answer.id}").click } }

      example 'いいね解除できること' do
        within(".answer_container") do
          expect { find(".unlike_#{answer.id}").click }.to change { answer.likes.count }.by(-1)
        end
      end
    end

    describe 'いいねボタン' do
      describe 'いいねしてない時' do
        before { within('.answer_container') { find(".like_#{answer.id}").click } }

        example '切り替わること' do
          within('.answer_container') do
            expect(page).to have_selector ".unlike_#{answer.id}"
          end
        end
      end

      describe 'いいねしている時' do
        before { within('.answer_container') { find(".like_#{answer.id}").click } }

        example '切り替わること' do
          within('.answer_container') do
            find(".unlike_#{answer.id}").click
            expect(page).to have_selector ".like_#{answer.id}"
          end
        end
      end
    end
  end
end
