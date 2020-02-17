require 'rails_helper'

RSpec.feature "Questions", type: :feature do
  include Warden::Test::Helpers
  let!(:user) { create(:user) }

  describe '質問の投稿' do
    before do
      login_as user, scope: :user
      visit questions_path
    end

    it '正常に投稿が出来ること' do
      fill_in 'question[title]', with: 'title'
      fill_in 'question[content]', with: 'content'
      expect { click_on '投稿する' }.to change { user.questions.count }.by(1)
    end

    it 'titleが空白の場合、失敗すること' do
      fill_in 'question[title]', with: ''
      fill_in 'question[content]', with: 'content'
      expect { click_on '投稿する' }.to change { user.questions.count }.by(0)
    end

    it 'contentが空白の場合、失敗すること' do
      fill_in 'question[title]', with: 'title'
      fill_in 'question[content]', with: ''
      expect { click_on '投稿する' }.to change { user.questions.count }.by(0)
    end
  end

  describe '質問の削除' do
    # 質問者 = 'taro'
    let(:taro) { create(:user, name: 'taro') }
    let(:jiro) { create(:user, name: 'jiro') }

    let!(:taro_q) { create(:question, user: taro) }

    it '質問者は質問を削除できること' do
      login_as taro, scope: :user
      visit question_path(taro_q.id)
      expect { find(".delete-q-#{taro_q.id}").click }.to change { taro.questions.count }.by(-1)
    end

    it '質問者しか削除できないこと' do
      login_as jiro, scope: :user
      visit question_path(taro_q.id)
      expect(page).not_to have_selector ".delete-q-#{taro_q.id}"
    end
  end
end
