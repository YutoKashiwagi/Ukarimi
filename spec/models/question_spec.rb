require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:question) { create(:question) }

  it '有効なファクトリを持つこと' do
    expect(question.valid?).to eq true
  end

  describe 'バリデーション' do
    context 'title' do
      subject { question.errors[:title] }

      it 'presence: true' do
        question.title = ''
        question.valid?
        is_expected.to include("を入力してください")
      end

      it 'length: { maximum: 50 }' do
        question.title = 'a' * 51
        question.valid?
        is_expected.to include("は50文字以内で入力してください")
      end
    end

    context 'content' do
      subject { question.errors[:content] }

      it 'presence: true' do
        question.content = ''
        question.valid?
        is_expected.to include("を入力してください")
      end

      it 'length: { maximum: 1000 }' do
        question.content = 'a' * 1001
        question.valid?
        is_expected.to include("は1000文字以内で入力してください")
      end
    end
  end

  describe 'dependent: :destroy' do
    let!(:taro) { create(:user, name: 'taro') }
    let!(:taro_q) { create(:question, user: taro) }

    it 'ユーザーを削除すると、紐づいた質問も削除されること' do
      expect { taro.destroy }.to change(Question, :count).by(-1)
    end
  end

  describe 'メソッドのテスト' do
    let!(:answer) { create(:answer, question: question) }

    describe 'has_best_answer?' do
      example 'trueを返すこと' do
        question.best_answer = answer
        expect(question.has_best_answer?).to eq true
      end

      example 'falseを返すこと' do
        expect(question.has_best_answer?).to eq false
      end
    end

    describe 'create_notification_best_answer(answer)' do
      context '回答者が質問者と異なる場合' do
        before { question.create_notification_best_answer(answer) }

        example 'ベストアンサーの通知が作成できている事' do
          expect(Notification.first.visitor).to eq question.user
          expect(Notification.first.visited).to eq answer.user
          expect(Notification.first.answer).to eq answer
          expect(Notification.first.action).to eq 'best_answer'
        end
      end

      context '回答者が質問者本人の場合' do
        let(:other_answer) { create(:answer, question: question, user: question.user) }

        example '通知が作成されていないこと' do
          expect do
            question.create_notification_best_answer(other_answer)
          end.not_to change(Notification, :count)
        end
      end
    end

    describe 'decide_best_answer(answer)' do
      example 'ベストアンサーを決定できること' do
        expect do
          question.decide_best_answer(answer)
        end.to change(question, :best_answer).from(nil).to(answer).
          and change(question, :solved).from(0).to(1)
      end

      context '既にベストアンサーが決定している場合' do
        let(:second_answer) { create(:answer, question: question) }

        example 'nilを返すこと' do
          question.decide_best_answer(answer)
          expect(question.decide_best_answer(second_answer)).to eq nil
        end
      end

      context '異なる質問の回答を引数に取った時' do
        let(:other_answer) { create(:answer) }

        example 'nilを返すこと' do
          expect(question.decide_best_answer(other_answer)).to eq nil
        end
      end
    end

    describe 'related_questions' do
      let(:category1) { create(:category) }
      let(:category2) { create(:category) }
      let(:category1_question) { create(:question) }
      let(:category2_question) { create(:question) }

      before do
        question.categories << category1
        category1_question.categories << category1
        category2_question.categories << category2
      end

      example '同じカテゴリの質問を取得できていること' do
        expect(question.related_questions.include?(category1_question)).to eq true
      end

      example '別カテゴリの質問は取得していないこと' do
        expect(question.related_questions.include?(category2_question)).to eq false
      end

      example 'レシーバー自体は取得していないこと' do
        expect(question.related_questions.include?(question)).to eq false
      end

      describe 'カテゴリー別で、同じ質問がある場合' do
        let(:category3) { create(:category) }

        before do
          question.categories << category3
          category1_question.categories << category3
        end

        example '同じ質問は一つしか取得してないこと' do
          expect(question.related_questions.count).to eq 1
        end
      end
    end
  end
end
