require 'rails_helper'

RSpec.describe "Questions", type: :system do
  let(:taro) { create(:user, name: 'taro') }
  let(:jiro) { create(:user, name: 'jiro') }
  let!(:taro_q) { create(:question, user: taro) }

  describe '質問の投稿' do
    before do
      login_as taro, scope: :user
      visit questions_path
    end

    it '正常に投稿が出来ること' do
      fill_in 'question[title]', with: 'title'
      fill_in 'question[content]', with: 'content'
      expect { click_on '投稿する' }.to change { taro.questions.count }.by(1)
    end

    describe 'カテゴリー' do
      let!(:category) { create(:category, name: 'category') }
      let!(:other_category) { create(:category, name: 'other_category') }

      before do
        visit questions_path
        fill_in 'question[title]', with: 'title'
        fill_in 'question[content]', with: 'content'
        check category.name
      end

      example 'タグを付けて質問できること' do
        click_on '投稿する'
        expect(page).to have_content category.name
      end

      example '選択していないタグがついていないこと' do
        click_on '投稿する'
        expect(page).not_to have_content other_category.name
      end
    end

    it 'titleが空白の場合、失敗すること' do
      fill_in 'question[title]', with: ''
      fill_in 'question[content]', with: 'content'
      expect { click_on '投稿する' }.to change { taro.questions.count }.by(0)
    end

    it 'contentが空白の場合、失敗すること' do
      fill_in 'question[title]', with: 'title'
      fill_in 'question[content]', with: ''
      expect { click_on '投稿する' }.to change { taro.questions.count }.by(0)
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

  describe '質問の編集' do
    before do
      login_as taro, scope: :user
      visit question_path(taro_q.id)
    end

    it 'editページリンクが機能していること' do
      find(".edit-q-#{taro_q.id}").click
      expect(current_path).to eq edit_question_path(taro_q.id)
    end

    describe '入力系' do
      subject { page }

      before { visit edit_question_path(taro_q.id) }

      context '正常値' do
        it '成功すること' do
          fill_in 'question[title]', with: '編集後のタイトル'
          fill_in 'question[content]', with: '編集後のコンテント'
          click_button '編集内容を送信'
          is_expected.to have_content '編集後のタイトル'
          is_expected.to have_content '編集後のコンテント'
        end
      end

      context '異常値' do
        it 'タイトルが空白' do
          fill_in 'question[title]', with: ''
          fill_in 'question[content]', with: '編集後のコンテント'
          click_button '編集内容を送信'
          is_expected.to have_content '編集に失敗しました'
        end

        it 'コンテントが空白' do
          fill_in 'question[title]', with: '編集後のタイトル'
          fill_in 'question[content]', with: ''
          click_button '編集内容を送信'
          is_expected.to have_content '編集に失敗しました'
        end
      end
    end

    describe 'タグ機能' do
      let!(:category) { create(:category, name: 'category') }

      before { visit edit_question_path(taro_q.id) }

      example 'タグを編集できること' do
        check category.name
        expect { click_button '編集内容を送信' }.to change { taro_q.categories.count }.by(1)
        expect(page).to have_content category.name
      end
    end
  end
end
