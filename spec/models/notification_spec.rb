require 'rails_helper'

RSpec.describe Notification, type: :model do
  shared_examples '通知も削除されること' do
    example '紐づいた通知が削除されること' do
      expect { target.destroy! }.to change(Notification, :count).by(-1)
    end
  end

  describe 'follow通知' do
    let!(:followee) { create(:user) }
    let!(:follower) { create(:user) }

    before { followee.follow(follower) }

    context 'followeeが削除された場合' do
      include_examples '通知も削除されること' do
        let(:target) { followee }
      end
    end

    context 'followerが削除された場合' do
      include_examples '通知も削除されること' do
        let(:target) { follower }
      end
    end
  end

  describe '回答、ベストアンサー通知' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    describe 'answer通知' do
      before { answer.user.create_notification_answer(answer) }

      context '質問が削除された場合' do
        include_examples '通知も削除されること' do
          let(:target) { question }
        end
      end

      context '回答が削除された場合' do
        include_examples '通知も削除されること' do
          let(:target) { answer }
        end
      end
    end

    describe 'ベストアンサー通知' do
      before do
        question.decide_best_answer(answer)
        question.create_notification_best_answer(answer)
      end

      context '質問が削除された場合' do
        include_examples '通知も削除されること' do
          let(:target) { question }
        end
      end

      context '回答が削除された場合' do
        include_examples '通知も削除されること' do
          let(:target) { answer }
        end
      end
    end
  end

  describe 'コメント通知' do
    shared_examples 'コメントまたはコメンタブルを削除した場合、通知も削除されること' do
      let!(:comment) { create(:comment, commentable: commentable) }
      before { commentable.create_notification_comment(comment.user, comment) }

      context 'commentableを削除したとき' do
        include_examples '通知も削除されること' do
          let!(:target) { commentable }
        end
      end

      context 'commentを削除したとき' do
        include_examples '通知も削除されること' do
          let(:target) { comment }
        end
      end
    end

    describe 'commentable => question' do
      include_examples 'コメントまたはコメンタブルを削除した場合、通知も削除されること' do
        let!(:commentable) { create(:question) }
      end
    end

    describe 'commentable => answer' do
      include_examples 'コメントまたはコメンタブルを削除した場合、通知も削除されること' do
        let!(:commentable) { create(:answer) }
      end
    end

    describe 'commentable => post' do
      include_examples 'コメントまたはコメンタブルを削除した場合、通知も削除されること' do
        let!(:commentable) { create(:post) }
      end
    end
  end
end
