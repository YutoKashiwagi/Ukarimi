require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it '有効なファクトリを持つこと' do
    expect(user.valid?).to eq true
  end

  describe 'バリデーション' do
    context 'name' do
      it 'presense :true' do
        user.name = ''
        user.valid?
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'length: {maximum: 20}' do
        user.name = 'a' * 21
        user.valid?
        expect(user.errors[:name]).to include("is too long (maximum is 20 characters)")
      end
    end
  end
end
