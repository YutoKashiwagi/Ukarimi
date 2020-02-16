require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { build(:answer) }

  it '有効なファクトリを持つこと' do
    expect(answer.valid?).to eq true
  end

  describe 'バリデーション' do
    context 'content' do
      subject { answer.errors[:content] }

      it 'presence: true' do
        answer.content = ''
        answer.valid?
        is_expected.to include("can't be blank")
      end

      it 'length: { maximum: 1000 }' do
        answer.content = 'a' * 1001
        answer.valid?
        is_expected.to include("is too long (maximum is 1000 characters)")
      end
    end
  end
end
