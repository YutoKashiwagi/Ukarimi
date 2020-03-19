require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:question) { build(:question) }
  let!(:answer) { create(:answer, question: question) }

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
    before { question.save }

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

        before { question.create_notification_best_answer(other_answer) }

        example '既読扱いの通知が作成されていること' do
          expect(Notification.first.visitor == Notification.first.visited).to eq true
          expect(Notification.first.checked).to eq true
        end
      end
    end

    describe 'decide_best_answer(answer)' do
      example 'ベストアンサーを決定できること' do
        expect do
          question.decide_best_answer(answer)
        end.to change(question, :best_answer).from(nil).to(answer).
          and change(question, :solved).from(0).to(1).
          and change(Notification, :count).by(1)
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
  end
end
