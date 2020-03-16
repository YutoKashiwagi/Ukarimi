require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { build(:question) }

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

    describe 'best_answer' do
      example 'ベストアンサーを返すこと' do
        question.best_answer = answer
        expect(question.best_answer).to eq answer
      end

      example 'nilを返すこと' do
        expect(question.best_answer).to eq nil
      end
    end
  end
end
