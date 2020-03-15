require 'rails_helper'

RSpec.describe "Likes::Questions", type: :system do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'ログインしていない時' do
    before { visit question_path(question.id) }

    example 'いいねボタンが表示されていないこと' do
      within(".question_container") do
        expect(page).not_to have_selector "like_#{question.id}"
        expect(page).not_to have_selector "unlike_#{question.id}"
      end
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example 'いいねできること' do
      within(".question_container") do
        expect { find(".like_#{question.id}").click }.to change { question.likes.count }.by(1)
        expect(page).to have_selector ".unlike_#{question.id}"
      end
    end

    describe 'いいねしてあるとき' do
      before { find(".like_#{question.id}").click }

      example 'いいね解除できること' do
        within(".question_container") do
          expect { find(".unlike_#{question.id}").click }.to change { question.likes.count }.by(-1)
        end
      end
    end

    describe 'いいねボタン' do
      describe 'いいねしてない時' do
        example '切り替わること' do
          within(".question_container") do
            expect { find(".like_#{question.id}").click }.to change { question.likes.count }.by(1)
            expect(page).to have_selector ".unlike_#{question.id}"
          end
        end
      end

      describe 'いいねしている時' do
        before { find(".like_#{question.id}").click }

        example '切り替わること' do
          within(".question_container") do
            expect { find(".unlike_#{question.id}").click }.to change { question.likes.count }.by(-1)
            expect(page).to have_selector ".like_#{question.id}"
          end
        end
      end
    end
  end
end
