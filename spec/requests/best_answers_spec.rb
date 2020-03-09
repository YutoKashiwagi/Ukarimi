require 'rails_helper'

RSpec.describe "BestAnswers", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }
  let(:best_answer_params) { { best: answer.id } }

  describe 'create' do
    context 'ログインしている時' do
      context '質問者本人の場合' do
        before { sign_in user }

        xexample 'ベストアンサーを決定できること' do
          expect do
            patch best_answer_path(question.id), params: { question: best_answer_params }
          end.to change(question, :best_answer).from(nil).to(answer)
        end

        example 'リダイレクトされること' do
          patch best_answer_path(question.id), params: { question: best_answer_params }
          expect(response).to redirect_to question_path(question.id)
        end
      end

      context '質問者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            patch best_answer_path(question.id), params: { question: best_answer_params }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { patch best_answer_path(question.id), params: { question: best_answer_params } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
