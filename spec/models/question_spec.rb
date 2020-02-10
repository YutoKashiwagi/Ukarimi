require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { build(:question) }

  it '有効なファクトリを持つこと' do
    expect(question.valid?).to eq true
  end

  describe 'バリデーション' do
    context 'content' do
      subject { question.errors[:content] }
      it 'presence: true' do
        question.content = ''
        question.valid?
        is_expected.to include("can't be blank")
      end

      it 'length: { maximum: 1000 }' do
        question.content = 'a' * 1001
        question.valid?
        is_expected.to include("is too long (maximum is 1000 characters)")
      end
    end
  end
end
