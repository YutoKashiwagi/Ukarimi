require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }
  let(:answer) { build(:answer, question: question) }

  it '有効なファクトリを持つこと' do
    expect(answer.valid?).to eq true
  end

  describe 'バリデーション' do
    context 'content' do
      subject { answer.errors[:content] }

      it 'presence: true' do
        answer.content = ''
        answer.valid?
        is_expected.to include("を入力してください")
      end

      it 'length: { maximum: 1000 }' do
        answer.content = 'a' * 1001
        answer.valid?
        is_expected.to include("は1000文字以内で入力してください")
      end
    end
  end

  describe 'dependent: :destroy' do
    let!(:taro) { create(:user, name: 'taro') }
    let!(:jiro) { create(:user, name: 'jiro') }
    let!(:taro_q) { create(:question, user: taro) }
    let!(:ans_jiro) { create(:answer, user: jiro, question: taro_q) }

    it '質問を消去すると、紐づいた回答も消去されること' do
      expect { taro_q.destroy }.to change(Answer, :count).by(-1)
    end

    it 'ユーザーを削除すると、紐づいた質問、回答も削除されること' do
      expect { taro.destroy }.to change(Question, :count).by(-1).and change(Answer, :count).by(-1)
    end
  end

  describe 'メソッド' do
    before { answer.save }

    describe 'is_best_answer?' do
      example 'trueを返すこと' do
        question.best = answer.id
        expect(answer.is_best_answer?).to eq true
      end

      example 'falseを返すこと' do
        expect(answer.is_best_answer?).to eq false
      end
    end
  end
end
