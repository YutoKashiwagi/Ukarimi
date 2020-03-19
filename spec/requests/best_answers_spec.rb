require 'rails_helper'

RSpec.describe "BestAnswers", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  describe 'create' do
    context 'ログインしている時' do
      context '質問者本人の場合' do
        before do
          sign_in user
        end

        example 'ベストアンサーを決定できること' do
          expect do
            post best_answers_path, params: { answer_id: answer.id, question_id: question.id }
          end.to change(Notification, :count).by(1)
          expect(question.best_answer).to eq answer
          expect(response).to redirect_to question_path(question.id)
        end

        context 'ベストアンサーが既に決定している時' do
          let(:second_answer) { create(:answer, question: question) }

          before do
            post best_answers_path, params: { answer_id: answer.id, question_id: question.id }
            post best_answers_path, params: { answer_id: second_answer.id, question_id: question.id }
          end

          example 'ベストアンサーが変わっていないこと' do
            expect(question.best_answer).to eq answer
            expect(response).to redirect_to question_path(question.id)
          end
        end

        context '異なる質問の回答をベストアンサーとして送信した場合' do
          let(:other_answer) { create(:answer) }

          example 'エラーが発生すること' do
            expect do
              post best_answers_path, params: { answer_id: other_answer.id, question_id: question.id }
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context '質問者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            post best_answers_path, params: { answer_id: answer.id, question_id: question.id }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { post best_answers_path, params: { answer_id: answer.id, question_id: question.id } }

      example 'サインイン画面へリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
