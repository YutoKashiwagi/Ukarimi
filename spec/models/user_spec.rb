require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:other_user) { create(:user) }
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
        expect { user.stock(question) }.to change { question.user.passive_notifications.count }.by(1)
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

  describe '通知関連' do
    before { user.save }

    describe 'create_notification_stock(question)' do
      context '本人以外がストックした場合' do
        before { user.create_notification_stock(question) }

        example 'ストック通知が作成できている事' do
          expect(Notification.first.visitor).to eq user
          expect(Notification.first.visited).to eq question.user
          expect(Notification.first.action).to eq 'stock'
          expect(Notification.first.question).to eq question
        end

        context '事前にストックされていた場合' do
          example '再度ストックされても通知が作成されないこと' do
            expect { user.stock(question) }.not_to change(Notification, :count)
          end
        end
      end

      context '本人がストックした場合' do
        before { question.user.create_notification_stock(question) }

        example '既読扱いの通知が作成されていること' do
          expect(Notification.first.checked).to eq true
        end
      end
    end

    describe 'create_notification_follow(other_user)' do
      before { user.create_notification_follow(other_user) }

      example 'フォロー通知が作成できていること' do
        expect(user.active_notifications.first.visitor).to eq user
        expect(user.active_notifications.first.visited).to eq other_user
        expect(user.active_notifications.first.action).to eq 'follow'
      end

      describe 'フォロー、フォロー解除が何度も行われた時' do
        before do
          user.follow(other_user)
          user.unfollow(other_user)
        end

        example '通知が一度しか作成されないこと' do
          expect { user.follow(other_user) }.not_to change { user.active_notifications.count }
        end
      end
    end

    describe 'create_notification_answer(answer)' do
      context '回答者が質問者と異なる場合' do
        let!(:answer) { create(:answer) }

        before { answer.user.create_notification_answer(answer) }

        example '回答通知が作成できている事' do
          expect(Notification.first.visitor).to eq answer.user
          expect(Notification.first.visited).to eq answer.question.user
          expect(Notification.first.action).to eq 'answer'
          expect(Notification.first.answer).to eq answer
        end
      end

      context '回答者が質問者本人の場合' do
        let!(:answer) { create(:answer, question: question, user: question.user) }

        before { answer.user.create_notification_answer(answer) }

        example '既読扱いの通知が作成できている事' do
          expect(Notification.first.visitor == Notification.first.visited).to eq true
          expect(Notification.first.checked).to eq true
        end
      end
    end

    describe 'has_notifications?' do
      context '未読の通知がある時' do
        before { user.passive_notifications.create(visitor: other_user, action: 'follow',) }

        example 'trueを返すこと' do
          expect(user.has_notifications?).to eq true
        end
      end

      context '未読の通知がない場合' do
        example 'falseを返すこと' do
          expect(user.has_notifications?).to eq false
        end
      end
    end

    describe 'create_notification_comment(comment, visited_id)' do
      context '本人以外がコメントした場合' do
        let!(:comment) { create(:comment) }

        before { comment.user.save_notification_comment(comment, comment.commentable.user.id) }

        example '正しい通知が作成されていること' do
          expect(Notification.first.visitor).to eq comment.user
          expect(Notification.first.visited).to eq comment.commentable.user
          expect(Notification.first.action).to eq 'comment'
          expect(Notification.first.comment).to eq comment
        end
      end

      context '本人がコメントした場合' do
        let!(:comment) { create(:comment, commentable: question, user: question.user) }

        before { comment.user.save_notification_comment(comment, comment.commentable.user.id) }

        example '既読扱いの通知が作成できていること' do
          expect(Notification.first.visitor == Notification.first.visited).to eq true
          expect(Notification.first.checked).to eq true
        end
      end
    end
  end

  describe 'フォロー関連' do
    before { user.save }

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
        expect { user.follow(other_user) }.to change { user.active_notifications.count }.by(1)
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

  describe 'ランキング関連' do
    before { user.save }

    let!(:user_second) { create(:user) }
    let!(:user_third) { create(:user) }

    describe 'create_ranking(obj)' do
      shared_examples 'ランキングのテスト' do
        before do
          create_list(test_instance, 3, user: user)
          create_list(test_instance, 2, user: user_second)
          create_list(test_instance, 1, user: user_third)
        end

        example '正常にソートできている事' do
          users = User.create_ranking(test_class)
          expect(users.first).to eq user
          expect(users.second).to eq user_second
          expect(users.third).to eq user_third
        end
      end

      context '回答数ランキング' do
        include_examples 'ランキングのテスト' do
          let(:test_instance) { :answer }
          let(:test_class) { Answer }
        end
      end

      context '質問数ランキング' do
        include_examples 'ランキングのテスト' do
          let(:test_instance) { :question }
          let(:test_class) { Question }
        end
      end
    end
  end
end
