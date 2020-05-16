require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  describe '通知ページのテスト' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: other_user, question: question) }

    before { login_as user, scope: :user }

    shared_examples '新着通知が存在しないこと' do
      example '通知が作成されていないこと' do
        expect(page).to have_content '通知はありません'
      end
    end

    describe 'ストック通知' do
      context '本人以外がストックした場合' do
        before do
          other_user.stocked_questions << question
          other_user.create_notification_stock(question)
          visit notifications_path
        end

        example 'ストック通知が作成されていること' do
          expect(page).to have_content "#{other_user.name}さんがあなたの質問をストックしました"
        end

        context 'ストックボタンを連打された時' do
          before do
            other_user.create_notification_stock(question)
            visit notifications_path
          end

          include_examples '新着通知が存在しないこと'
        end
      end

      context '本人がストックした場合' do
        before do
          user.stocked_questions << question
          user.create_notification_stock(question)
          visit notifications_path
        end

        include_examples '新着通知が存在しないこと'
      end
    end

    describe 'フォロー通知' do
      before do
        other_user.follow(user)
        visit notifications_path
      end

      example '通知されていること' do
        expect(page).to have_content "#{other_user.name}さんがあなたをフォローしました"
      end

      context 'フォローボタンを連打された時' do
        before do
          other_user.unfollow(user)
          other_user.follow(user)
          visit notifications_path
        end

        include_examples '新着通知が存在しないこと'
      end
    end

    describe '回答通知' do
      context '回答者が質問者本人でない場合' do
        before do
          other_user.create_notification_answer(answer)
          visit notifications_path
        end

        example '通知されていること' do
          expect(page).to have_content "#{other_user.name}さんがあなたの質問に回答しました"
        end
      end

      context '回答者が質問者本人の場合' do
        let!(:other_answer) { create(:answer, question: question, user: user) }

        before do
          other_answer.user.create_notification_answer(other_answer)
          visit notifications_path
        end

        include_examples '新着通知が存在しないこと'
      end
    end

    describe 'ベストアンサー通知' do
      context '回答者と質問者が異なる場合' do
        let!(:question2) { create(:question) }
        let!(:answer2) { create(:answer, question: question2) }

        before do
          login_as question2.user, scope: :user
          question2.decide_best_answer(answer2)
          question2.create_notification_best_answer(answer2)
        end

        example '通知されていること', js: true do
          login_as answer2.user
          visit notifications_path
          expect(page).to have_content "#{answer2.user.name}さんがあなたの回答をベストアンサーに決定しました"
        end
      end

      context '質問者本人の場合' do
        let!(:user_answer) { create(:answer, question: question, user: user) }

        before do
          question.decide_best_answer(user_answer)
          visit notifications_path
        end

        include_examples '新着通知が存在しないこと'
      end
    end

    describe 'コメント通知' do
      shared_examples 'コメント通知のテスト' do
        let!(:comment) { create(:comment, commentable: commentable) }

        describe 'commentable.user以外がコメントした場合' do
          context '事前にコメントされてない場合' do
            before do
              login_as comment.commentable.user, scope: :user
              comment.commentable.create_notification_comment(comment.user, comment)
              visit notifications_path
            end

            example 'commentable.userへの通知されていること' do
              expect(page).to have_content first_notification_text
            end
          end

          context '事前にコメントされている場合' do
            let!(:other_comment) { create(:comment, commentable: commentable) }

            before do
              other_comment.commentable.create_notification_comment(other_comment.user, other_comment)
              login_as comment.user, scope: :user
              visit notifications_path
            end

            example '事前にコメントしているユーザーへ通知されていること' do
              expect(page).to have_content second_notification_text
            end
          end
        end

        describe 'commentable.userがコメントした場合' do
          let!(:comment) { create(:comment, commentable: commentable, user: commentable.user) }

          before do
            comment.commentable.create_notification_comment(comment.user, comment)
            visit notifications_path
          end

          example '通知が作成されていないこと' do
            expect(page).to have_content '通知はありません'
          end
        end
      end

      describe 'commentable => question' do
        include_examples 'コメント通知のテスト' do
          let(:first_notification_text) { "#{comment.user.name}さんが質問にコメントしました" }
          let(:second_notification_text) { "#{other_comment.user.name}さんが質問にコメントしました" }
          let!(:commentable) { question }
        end
      end

      describe 'commentable => answer' do
        include_examples 'コメント通知のテスト' do
          let(:first_notification_text) { "#{comment.user.name}さんが質問の回答にコメントしました" }
          let(:second_notification_text) { "#{other_comment.user.name}さんが質問の回答にコメントしました" }
          let!(:commentable) { create(:answer) }
        end
      end

      describe 'commentable => post' do
        include_examples 'コメント通知のテスト' do
          let(:first_notification_text) { "#{comment.user.name}さんがつぶやきにコメントしました" }
          let(:second_notification_text) { "#{other_comment.user.name}さんがつぶやきにコメントしました" }
          let!(:commentable) { create(:post) }
        end
      end
    end
  end
end
