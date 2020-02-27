require 'rails_helper'

RSpec.feature "BestAnswers", type: :feature do
  include Warden::Test::Helpers

  let!(:taro) { create(:user) }
  let!(:taro_q) { create(:question, user: taro) }
  let!(:jiro) { create(:user) }
  let!(:jiro_ans) { create(:answer, question: taro_q, user: jiro, content: 'jiroの回答') }

  describe 'ベストアンサー' do
    before do
      login_as taro, scope: :user
      visit question_path(taro_q.id)
    end

    xexample 'ベストアンサーを決定できること' do
      expect(page).not_to have_content 'ベストアンサー！'
      click_button 'ベストアンサー'
      sleep 1
      within('.modal-footer') { click_on '決定' }
      expect(page).to have_content 'ベストアンサー！'
    end

    xcontext '一度ベストアンサーを決めた場合' do
      let!(:answer) { create(:answer, question: taro_q) }

      before { visit question_path(taro_q.id) }

      example 'ベストアンサーを変更できないこと' do
        expect(page).to have_button 'ベストアンサー', count: 2
        find(".best_answer_btn_#{jiro_ans.id}").click
        sleep 1
        within('.modal-footer') { click_on '決定' }
        expect(page).not_to have_button 'ベストアンサー'
      end
    end

    example '質問者でなければ、ベストアンサーに選べないこと' do
      login_as jiro, scope: :user
      visit question_path(taro_q.id)
      expect(page).not_to have_content 'ベストアンサー'
    end
  end
end
