require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:question_params) { { title: 'title', content: 'content' } }

  shared_examples 'リクエストが成功すること' do
    example 'returns 200' do
      expect(response).to have_http_status(200)
    end
  end

  shared_examples 'サインイン画面へリダイレクトされること' do
    example 'redirect_to new_user_session_path' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "questions#index" do
    before { get questions_path }

    it_behaves_like 'リクエストが成功すること'
  end

  describe 'questions#show' do
    before { get question_path(question.id) }

    it_behaves_like 'リクエストが成功すること'
  end

  describe 'questions#new' do
    context 'ログインしている時' do
      before do
        sign_in user
        get new_question_path
      end

      it_behaves_like 'リクエストが成功すること'
    end

    context 'ログインしていない時' do
      before { get new_question_path }

      it_behaves_like 'サインイン画面へリダイレクトされること'
    end
  end

  describe 'questions#create' do
    context 'ログインしている時' do
      before do
        sign_in user
      end

      example '正常に質問を作成できること' do
        expect do
          post questions_path, params: { question: question_params }
        end.to change { user.questions.count }.by(1)
      end
    end

    context 'ログインしていない時' do
      example '質問を投稿できないこと' do
        expect { post questions_path, params: { question: question_params } }.to change(Question, :count).by(0)
      end
    end
  end

  describe 'questions#destroy' do
    context 'ログインしている時' do
      context '質問作成者本人の場合' do
        before do
          sign_in user
        end

        example '正常に削除できること' do
          expect do
            delete question_path(question.id)
          end.to change { user.questions.count }.by(-1)
        end
      end

      context '質問作成者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect { delete question_path(question.id) }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない場合' do
      before { delete question_path(question.id) }

      it_behaves_like 'サインイン画面へリダイレクトされること'
    end
  end

  describe 'questions#edit' do
    context 'ログインしている時' do
      context '質問者本人の場合' do
        before do
          sign_in user
          get edit_question_path(question.id)
        end

        it_behaves_like 'リクエストが成功すること'
      end

      context '質問者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect { get edit_question_path(question.id) }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { get edit_question_path(question.id) }

      it_behaves_like 'サインイン画面へリダイレクトされること'
    end
  end

  describe 'question#update' do
    context 'ログインしている時' do
      context '質問者本人の場合' do
        before { sign_in user }

        example '成功すること' do
          patch question_path(question.id), params: { question: question_params }
          expect(response).to redirect_to question_path(question.id)
        end
      end

      context '質問者本人でない場合' do
        before { sign_in other_user }

        example 'エラーが発生すること' do
          expect do
            patch question_path(question.id),
                  params: { question: question_params }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ログインしていない時' do
      before { patch question_path(question.id) }

      it_behaves_like 'サインイン画面へリダイレクトされること'
    end
  end
end
