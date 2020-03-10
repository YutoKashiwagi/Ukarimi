require 'rails_helper'

RSpec.describe "Comments::Answers", type: :system do
  include Warden::Test::Helpers

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:comment) { create(:comment, commentable: answer) }

  describe 'ログインしていないとき' do
    example 'コメントフォームが存在しないこと' do
      expect(page).not_to have_selector ".comment_form_#{comment.commentable.id}"
    end
  end

  describe 'Create' do
    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example '正常に作成できること' do
      within('.answer_container') do
        fill_in 'comment[content]', with: 'ああああああ'
        expect { click_button 'コメントする' }.to change { answer.comments.count }.by(1)
      end
      expect(page).to have_content 'あああああ'
    end

    example '空白のまま送信した場合、失敗すること' do
      within('.answer_container') do
        expect { click_button 'コメントする' }.to change { answer.comments.count }.by(0)
      end
      expect(page).to have_content '失敗しました'
    end

    example '1001文字以上のコメントを送信した場合、失敗する' do
      within('.answer_container') do
        fill_in 'comment[content]', with: 'a' * 1001
        expect { click_button 'コメントする' }.to change { answer.comments.count }.by(0)
      end
      expect(page).to have_content '失敗しました'
    end
  end

  describe 'Destroy' do
    let!(:comment2) { create(:comment, commentable: answer, user: user) }

    before do
      login_as user, scope: :user
      visit question_path(question.id)
    end

    example 'コメントした本人ならば、コメントを削除できること' do
      expect { find(".delete_comment_#{comment2.id}").click }.to change { answer.comments.count }.by(-1)
    end

    example 'コメントした本人でなければ、コメントを削除できないこと' do
      expect(page).not_to have_selector ".delete_comment_#{comment.id}"
    end
  end
end
