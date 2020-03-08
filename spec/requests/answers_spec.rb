require 'rails_helper'

RSpec.describe "Answers", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:answer_params) { { content: 'content', question_id: question.id } }

  describe 'create' do
    context 'ログインしている時' do
      before do
        sign_in user
      end

      example '正常に作成できること' do
        expect do
          post question_answers_path(question.id), params: { answer: answer_params }
        end.to change { question.answers.count }.by(1)
      end
    end

    context 'ログインしていない時' do
      before { post question_answers_path(question.id), params: { answer: answer_params } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'destoy' do
    context 'ログインしている時' do
      context '回答者の場合' do
        before { sign_in user }

        example '削除できること' do
          expect do
            delete answer_path(answer.id)
          end.to change { question.answers.count }.by(-1)
        end
      end

      context '回答者でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            delete answer_path(answer.id)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { delete answer_path(answer.id) }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'edit' do
    context 'ログインしている時' do
      context '回答者本人の場合' do
        before do
          sign_in user
          get edit_answer_path(answer.id)
        end

        example '200レスポンスを返すこと' do
          expect(response).to have_http_status(200)
        end
      end

      context '回答者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            get edit_answer_path(answer.id)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { get edit_answer_path(answer.id) }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'update' do
    context 'ログインしている時' do
      context '回答者本人の場合' do
        before do
          sign_in user
          patch answer_path(answer.id), params: { answer: answer_params }
        end

        example '正常にリダイレクトされること' do
          expect(response).to redirect_to question_path(answer.question.id)
        end
      end

      context '回答者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            patch answer_path(answer.id), params: { answer: answer_params }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { patch answer_path(answer.id), params: { answer: answer_params } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
