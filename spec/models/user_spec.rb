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
        is_expected.to include("を入力してください")
      end

      it 'length: {maximum: 20}' do
        user.name = 'a' * 21
        user.valid?
        is_expected.to include("は20文字以内で入力してください")
      end
    end

    context 'password' do
      subject { user.errors[:password] }

      it 'maximum: 30' do
        user.password = 'a' * 31
        user.valid?
        is_expected.to include("は30文字以内で入力してください")
      end

      it 'minimum: 6' do
        user.password = 'a' * 5
        user.valid?
        is_expected.to include("は6文字以上で入力してください")
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

    describe 'dependent: :destrou' do
      before { user.stock(question) }

      example 'ユーザーを削除すると、紐づいたストックも削除されること' do
        expect { user.destroy }.to change(Stock, :count).by(-1)
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

  describe 'タグ、カテゴリー関連' do
    let!(:category) { create(:category, name: 'category') }

    before { user.save }

    describe 'following_category?(category)' do
      context 'フォローしている時' do
        before { user.categories << category }

        example 'trueを返すこと' do
          expect(user.following_category?(category)).to eq true
        end
      end

      context 'フォローしていない時' do
        example 'falseを返すこと' do
          expect(user.following_category?(category)).to eq false
        end
      end
    end

    describe 'follow_category(category)' do
      context 'フォローしている時' do
        before { user.categories << category }

        example '再度フォローできないこと' do
          expect { user.follow_category(category) }.to change { user.categories.count }.by(0)
        end
      end

      context 'フォローしていない時' do
        example 'フォローできること' do
          expect { user.follow_category(category) }.to change { user.categories.count }.by(1)
        end
      end
    end

    describe 'unfollow_category(category)' do
      context 'フォローしている時' do
        before { user.follow_category(category) }

        example 'フォロー解除できること' do
          expect { user.unfollow_category(category) }.to change { user.categories.count }.by(-1)
        end
      end

      context 'フォローしていない時' do
        example '再度フォロー解除できないこと' do
          expect { user.unfollow_category(category) }.to change { user.categories.count }.by(0)
        end
      end
    end
  end
end
