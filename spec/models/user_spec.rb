require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:question) { create(:question) }

  it '有効なファクトリを持つこと' do
    expect(user.valid?).to eq true
  end

  describe 'バリデーション' do
    context 'name' do
      subject { user.errors[:name] }

      it 'presense :true' do
        user.name = ''
        user.valid?
        is_expected.to include("can't be blank")
      end

      it 'length: {maximum: 20}' do
        user.name = 'a' * 21
        user.valid?
        is_expected.to include("is too long (maximum is 20 characters)")
      end
    end

    context 'password' do
      subject { user.errors[:password] }

      it 'maximum: 30' do
        user.password = 'a' * 31
        user.valid?
        is_expected.to include("is too long (maximum is 30 characters)")
      end

      it 'minimum: 6' do
        user.password = 'a' * 5
        user.valid?
        is_expected.to include("is too short (minimum is 6 characters)")
      end
    end
  end

  describe 'ストック関連' do
    before { user.save }

    describe 'stocked?(question)' do
      example 'ストックしている場合、trueを返すこと' do
        user.stocked_questions << question
        expect(user.stocked?(question)).to eq true
      end

      example 'ストックしていない場合、falseを返すこと' do
        expect(user.stocked?(question)).to eq false
      end
    end

    describe 'stock(question)' do
      example 'ストックしていない場合、ストック出来ること' do
        user.stock(question)
        expect(user.stocked?(question)).to eq true
      end

      example 'ストックしている場合、nilを返すこと' do
        user.stock(question)
        expect(user.stock(question)).to eq nil
      end
    end

    describe 'unstock(question)' do
      example 'ストックしている場合、ストックを解除できること' do
        user.stock(question)
        expect { user.unstock(question) }.to change { user.stocked_questions.count }.by(-1)
      end

      example 'ストックしていない場合、nilを返すこと' do
        expect(user.unstock(question)).to eq nil
      end
    end
  end

  describe 'フォロー関連' do
    before { user.save }

    let(:other_user) { create(:user) }

    describe 'following?(other_user)' do
      example 'フォローしていない場合、falseを返すこと' do
        expect(user.following?(other_user)).to eq false
      end

      example 'フォローしている場合、trueを返すこと' do
        user.followees << other_user
        expect(user.following?(other_user)).to eq true
      end
    end

    describe 'follow(other_user)' do
      example 'フォローしていない場合、フォローできること' do
        user.follow(other_user)
        expect(user.following?(other_user)).to eq true
      end

      example 'フォローしている場合、nilを返すこと' do
        user.follow(other_user)
        expect(user.follow(other_user)).to eq nil
      end

      example '自分自身をフォローできないこと' do
        expect(user.follow(user)).to eq nil
      end
    end

    describe 'unfollow(other_user)' do
      example 'フォローしていない場合、nilを返すこと' do
        expect(user.unfollow(other_user)).to eq nil
      end

      example 'フォローしている場合、フォロー解除できること' do
        user.follow(other_user)
        user.unfollow(other_user)
        expect(user.following?(other_user)).to eq false
      end
    end
  end
end
