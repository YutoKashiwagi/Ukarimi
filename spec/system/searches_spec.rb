require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let!(:category1) { create(:category, name: 'category1') }
  let!(:category2) { create(:category, name: 'category2') }
  let!(:question) { create(:question, title: 'hoge', content: 'foo') }

  before { visit searches_path }

  describe '検索条件のテスト' do
    describe '解決済みかどうかでの検索' do
      context '未解決の場合' do
        example '未解決の質問を返すこと' do
          find('#q_solved_eq_0').click
          click_button '検索'
          expect(page).to have_content question.title
        end

        example '解決済みの質問は返さないこと' do
          find('#q_solved_eq_1').click
          click_button '検索'
          expect(page).to have_content '一致する情報は見つかりませんでした。'
        end
      end

      context '解決済みの場合' do
        before { question.update_attribute(:solved, 1) }

        example '解決済みの質問を返すこと' do
          find('#q_solved_eq_1').click
          click_button '検索'
          expect(page).to have_content question.title
        end

        example '未解決の質問は返さないこと' do
          find('#q_solved_eq_0').click
          click_button '検索'
          expect(page).to have_content '一致する情報は見つかりませんでした。'
        end
      end
    end

    describe 'カテゴリーの検索' do
      before { question.categories << category1 }

      example '選択したカテゴリーの質問を返すこと' do
        select category1.name, from: 'q[categories_id_eq]'
        click_button '検索'
        expect(page).to have_content question.title
      end

      example '正しいカテゴリーの質問を返すこと' do
        select category2.name, from: 'q[categories_id_eq]'
        click_button '検索'
        expect(page).to have_content '一致する情報は見つかりませんでした。'
      end
    end

    describe 'フリーワード検索' do
      example 'タイトルで検索できること' do
        fill_in 'q[title_or_content_or_categories_name_cont]', with: 'hog'
        click_button '検索'
        expect(page).to have_content question.title
      end

      example '内容で検索できること' do
        fill_in 'q[title_or_content_or_categories_name_cont]', with: 'fo'
        click_button '検索'
        expect(page).to have_content question.title
      end

      example 'カテゴリー名で検索できること' do
        question.categories << category1
        fill_in 'q[title_or_content_or_categories_name_cont]', with: 'catego'
        click_button '検索'
        expect(page).to have_content question.title
      end

      example '該当しない質問は返さないこと' do
        fill_in 'q[title_or_content_or_categories_name_cont]', with: 'hello_world'
        click_button '検索'
        expect(page).to have_content '一致する情報は見つかりませんでした。'
      end
    end
  end
end
