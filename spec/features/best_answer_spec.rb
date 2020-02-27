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

    example 'ベストアンサーを決定できること' do
      click_button 'ベストアンサー'
      expect(taro_q.has_best_answer?).to eq false
      expect(page).to have_content 'ベストアンサー！'
    end
  end
end
