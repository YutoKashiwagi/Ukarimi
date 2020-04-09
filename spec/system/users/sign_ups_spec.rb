require 'rails_helper'

RSpec.describe "SignUps", type: :system do
  before do
    visit new_user_registration_path
    fill_in 'お名前', with: 'foobar'
    fill_in 'メールアドレス', with: 'foobar@foobar.com'
    fill_in 'パスワード', with: 'foobar'
    fill_in '確認用パスワード', with: 'foobar'
  end

  example '正常にサインアップできること' do
    click_button 'アカウント登録'
    expect(page).to have_content 'アカウント登録が完了しました'
  end

  describe '異常値' do
    describe 'お名前' do
      context '空白の場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'お名前', with: ''
          click_button 'アカウント登録'
          expect(page).to have_content 'お名前を入力してください'
        end
      end

      context '文字数オーバーの場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'お名前', with: 'a' * 21
          click_button 'アカウント登録'
          expect(page).to have_content 'お名前は20文字以内で入力してください'
        end
      end
    end

    describe 'メールアドレス' do
      context '空白の場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'メールアドレス', with: ''
          click_button 'アカウント登録'
          expect(page).to have_content 'メールアドレスを入力してください'
        end
      end

      context '文字数オーバーの場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'メールアドレス', with: 'a' * 256 + '@example.com'
          click_button 'アカウント登録'
          expect(page).to have_content 'メールアドレスは256文字以内で入力してください'
        end
      end

      context '重複している場合' do
        before { create(:user, email: 'foobar@foobar.com') }

        example '失敗し、エラーメッセージが表示されること' do
          click_button 'アカウント登録'
          expect(page).to have_content 'メールアドレスはすでに存在します'
        end
      end
    end

    describe 'パスワード' do
      context '空白の場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'パスワード', with: ''
          fill_in '確認用パスワード', with: ''
          click_button 'アカウント登録'
          expect(page).to have_content 'パスワードを入力してください'
        end
      end

      context '文字数オーバーの場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'パスワード', with: 'a' * 31
          fill_in '確認用パスワード', with: 'a' * 31
          click_button 'アカウント登録'
          expect(page).to have_content 'パスワードは30文字以内で入力してください'
        end
      end

      context '文字数が少ない場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'パスワード', with: 'a' * 5
          fill_in '確認用パスワード', with: 'a' * 5
          click_button 'アカウント登録'
          expect(page).to have_content 'パスワードは6文字以上で入力してください'
        end
      end

      context 'パスワードが確認用と異なる場合' do
        example '失敗し、エラーメッセージが表示されること' do
          fill_in 'パスワード', with: 'password'
          fill_in '確認用パスワード', with: 'hogehoge'
          click_button 'アカウント登録'
          expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
        end
      end
    end
  end
end
