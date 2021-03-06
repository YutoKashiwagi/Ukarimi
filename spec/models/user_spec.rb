require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question) }

  example '有効なファクトリを持つこと' do
    expect(user.valid?).to eq true
  end

  example '正常に作成できること' do
    expect { user.save }.to change(User, :count).by(1)
  end

  example '正常に削除できること' do
    user.save
    expect { user.destroy! }.to change(User, :count).by(-1)
  end

  describe 'バリデーション' do
    context 'name' do
      subject { user.errors[:name] }

      example 'presense :true' do
        user.name = ''
        user.valid?
        is_expected.to include("を入力してください")
      end

      example 'length: {maximum: 20}' do
        user.name = 'a' * 21
        user.valid?
        is_expected.to include("は20文字以内で入力してください")
      end
    end

    context 'password' do
      subject { user.errors[:password] }

      example 'maximum: 30' do
        user.password = 'a' * 31
        user.valid?
        is_expected.to include("は30文字以内で入力してください")
      end

      example 'minimum: 6' do
        user.password = 'a' * 5
        user.valid?
        is_expected.to include("は6文字以上で入力してください")
      end
    end

    context 'profile' do
      example 'length: { maximum: 400 }' do
        user.profile = 'a' * 401
        user.valid?
        expect(user.errors[:profile]).to include("は400文字以内で入力してください")
      end
    end
  end

  describe 'ストック関連' do
    before { user.save }

    describe 'dependent: :destroy' do
      before { user.stocked_questions << question }

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
            expect { user.create_notification_stock(question) }.not_to change(Notification, :count)
          end
        end
      end

      context '本人がストックした場合' do
        example '通知が作成されていないこと' do
          expect do
            question.user.create_notification_stock(question)
          end.not_to change(Notification, :count)
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

        example '通知が作成されていないこと' do
          expect do
            answer.user.create_notification_answer(answer)
          end.not_to change(Notification, :count)
        end
      end
    end

    describe 'has_new_notifications?' do
      context '未読の通知がある時' do
        before { user.passive_notifications.create(visitor: other_user, action: 'follow',) }

        example 'trueを返すこと' do
          expect(user.has_new_notifications?).to eq true
        end
      end

      context '未読の通知がない場合' do
        example 'falseを返すこと' do
          expect(user.has_new_notifications?).to eq false
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

        example '通知が作成されていないこと' do
          expect do
            comment.user.save_notification_comment(comment, comment.commentable.user.id)
          end.not_to change(Notification, :count)
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

  describe 'ゲストユーザー機能' do
    describe 'User.guest' do
      context 'seeds.rbで定義したゲストユーザーが削除されてない場合' do
        let!(:guest) { create(:user, email: 'guest@guest.com', role: :guest) }

        example 'ゲストユーザーを返すこと' do
          expect(User.guest).to eq guest
        end
      end

      context 'ゲストユーザーが削除されている時' do
        example 'ゲストユーザーを返すこと' do
          expect(User.guest.guest?).to eq true
        end
      end
    end
  end

  describe 'フィード機能' do
    describe 'followee_items()' do
      let!(:followee) { create(:user) }
      let!(:unfollowee) { create(:user) }

      before do
        user.save
        user.follow(followee)
      end

      describe 'Questionを引数に取った時' do
        let!(:followee_question) { create(:question, user: followee) }
        let!(:unfollowee_question) { create(:question, user: unfollowee) }

        example 'フォロワーの質問を含み、フォローしてない人の質問を含まないこと' do
          expect(user.followee_items(Question)).to include(followee_question)
          expect(user.followee_items(Question)).not_to include(unfollowee_question)
        end
      end

      describe 'Postを引数に取った時' do
        let!(:followee_post) { create(:post, user: followee) }
        let!(:unfollowee_post) { create(:post, user: unfollowee) }

        example 'フォロワーのつぶやきを含み、フォローしてない人のつぶやきを含まないこと' do
          expect(user.followee_items(Post)).to include(followee_post)
          expect(user.followee_items(Post)).not_to include(unfollowee_post)
        end
      end
    end

    describe 'カテゴリーのフィード' do
      let!(:followed_category) { create(:category) }
      let!(:unfollowed_category) { create(:category) }

      before do
        user.follow_category(followed_category)
      end

      shared_examples 'mycategory_items(Model)のテスト' do
        # item => インスタンス(ユーザーがフォロー中のカテゴリーを含む)
        # ohter_item => インスタンス(フォロー中のカテゴリーを含まない)
        # item_class => itemのクラス
        before do
          item.categories << followed_category
          other_item.categories << unfollowed_category
        end

        example 'フォロー中のカテゴリーを含むアイテムを含み、フォローしてないカテゴリーのみのアイテムは含まないこと' do
          expect(user.mycategory_items(item_class).include?(item)).to eq true
          expect(user.mycategory_items(item_class).include?(other_item)).not_to eq true
        end

        context '複数のカテゴリーを含むアイテムがある場合' do
          let!(:followed_category2) { create(:category) }

          before do
            user.follow_category(followed_category2)
            item.categories << followed_category2
          end

          example 'アイテムが重複していないこと' do
            expect(user.mycategory_items(item_class).count).to eq 1
          end
        end
      end

      describe 'mycategory_items(Question)' do
        include_examples 'mycategory_items(Model)のテスト' do
          let!(:item) { create(:question) }
          let!(:other_item) { create(:question) }
          let!(:item_class) { Question }
        end
      end

      describe 'mycategory_items(Post)' do
        include_examples 'mycategory_items(Model)のテスト' do
          let!(:item) { create(:post) }
          let!(:other_item) { create(:post) }
          let!(:item_class) { Post }
        end
      end
    end
  end
end
