require 'rails_helper'

RSpec.feature "Answers", type: :feature do
  include Warden::Test::Helpers
  subject { page }

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'ログインしていない時' do
    it '回答フォームが存在しないこと' do
      login_as user, scope: :user
      visit question_path(question.id)
      expect(page).not_to have_content '回答する'
    end
  end

  describe 'ログインしている時' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    it '正常に回答できること' do
      fill_in 'answer[content]', with: ' 正しい回答'
      click_button '回答する'
      is_expected.to have_content '正しい回答'
    end

    it 'presence: true' do
      fill_in 'answer[content]', with: ''
      click_button '回答する'
      is_expected.to have_content '回答に失敗しました'
    end

    it 'length: { maximum: 1000 }' do
      fill_in 'answer[content]', with: 'a' * 1001
      click_button '回答する'
      is_expected.to have_content '回答に失敗しました'
    end
  end

  describe '削除機能が正常に働いていること' do
    # taro = 質問者
    let!(:taro) { create(:user, name: 'taro') }
    let!(:taro_q) { create(:question, user: taro) }

    let!(:user_first) { create(:user, name: 'first') }
    let!(:user_second) { create(:user, name: 'second') }
    let!(:user_third) { create(:user, name: 'third') }

    let!(:answer_first) { create(:answer, content: '一番目の回答', user: user_first, question: taro_q) }
    let!(:answer_second) { create(:answer, content: '二番目の回答', user: user_second, question: taro_q) }

    it '回答者しか自分の回答を削除できないこと' do
      # user_thirdがuser_firstの回答を削除しようとする
      login_as user_third, scope: :user
      visit question_path(taro_q.id)
      expect(page).not_to have_selector ".delete-#{answer_first.id}"
    end

    it '回答者は自分の投稿を削除できること' do
      login_as user_first, scope: :user
      visit question_path(taro_q.id)
      expect(page).to have_content '一番目の回答'
      expect { find(".delete-#{answer_first.id}").click }.to change { taro_q.answers.count }.by(-1)
      expect(page).not_to have_content '一番目の回答'
    end

    # 一つの回答に対して、同一人物が複数の回答を投稿している時
    # その人物が一つの回答を削除すると、残りも削除されてしまう
    it 'バグ再現テスト' do
      answer_third = create(:answer, user: user_third, question: taro_q, content: 'answer_thirdの回答1')
      create(:answer, user: user_third, question: taro_q, content: 'answer_thirdの回答2')
      login_as user_third, scope: :user
      visit question_path(taro_q.id)
      expect { find(".delete-#{answer_third.id}").click }.to change { user_third.answers.count }.by(-1)
      expect(page).to have_content 'answer_thirdの回答2'
    end
  end
end
