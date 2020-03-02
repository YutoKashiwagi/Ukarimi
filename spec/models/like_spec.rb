require 'rails_helper'

RSpec.describe Like, type: :model do
  shared_examples 'likableで使用可能なメソッド' do
    # include時に定義する部分
    # let(:like_user) { create(:user) }
    # let(:like) { build(:like, user: like_user, likable: likable) }
    # let(:likable) 

    describe 'liked_users' do
      before { like.save }

      example 'いいねしたユーザーを取得できること' do
        expect(likable.liked_users.include?(like_user)).to eq true
      end
    end

    describe 'liked?(user)' do
      subject { likable.liked?(like_user) }

      context 'いいねしている場合' do
        before { like.save }

        example 'trueを返すこと' do
          is_expected.to eq true
        end
      end

      context 'いいねしていない場合' do
        example 'falseを返すこと' do
          is_expected.to eq false
        end
      end
    end

    describe 'liked_by(user)' do
      context 'いいねしている場合' do
        before { like.save }

        example 'いいねできないこと' do
          expect { likable.liked_by(like_user) }.to change { likable.likes.count }.by(0)
        end
      end

      context 'いいねしてない場合' do
        example 'いいねできること' do
          expect { likable.liked_by(like_user) }.to change { likable.likes.count }.by(1)
        end
      end
    end

    describe 'unliked_by(user)' do
      context 'いいねしている場合' do
        before { like.save }

        example 'いいね解除できること' do
          expect { likable.unliked_by(like_user) }.to change { likable.likes.count }.by(-1)
        end
      end

      context 'いいねしていない場合'
      example 'nilを返すこと' do
        expect(likable.unliked_by(like_user)).to eq nil
      end
    end
  end

  describe 'Question' do
    include_examples 'likableで使用可能なメソッド' do
      let(:like_user) { create(:user) }
      let(:likable) { create(:question) }
      let(:like) { build(:like, user: like_user, likable: likable) }
    end
  end

  describe 'Answer' do
    include_examples 'likableで使用可能なメソッド' do
      let(:like_user) { create(:user) }
      let(:likable) { create(:answer) }
      let(:like) { build(:like, user: like_user, likable: likable) }
    end
  end
end
