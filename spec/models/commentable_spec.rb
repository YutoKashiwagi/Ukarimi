require 'rails_helper'

RSpec.describe Commentable, type: :model do
  shared_examples 'コメント通知のテスト' do
    let!(:comment) { create(:comment, commentable: commentable) }
    context '他にコメントがない場合' do
      before { comment.commentable.create_notification_comment(comment.user, comment) }

      example 'commetable.user宛の通知が作成できていること' do
        expect(Notification.first.visitor).to eq comment.user
        expect(Notification.first.visited).to eq comment.commentable.user
        expect(Notification.first.comment).to eq comment
        expect(Notification.first.action).to eq 'comment'
      end
    end

    context '他にコメントがある場合' do
      let!(:other_comment) { create(:comment, commentable: commentable) }

      before { comment.commentable.create_notification_comment(other_comment.user, other_comment) }

      example '先にコメントした人宛の通知が作成されていること' do
        expect(comment.user.passive_notifications.first.visitor).to eq other_comment.user
        expect(comment.user.passive_notifications.first.visited).to eq comment.user
        expect(comment.user.passive_notifications.first.action).to eq 'comment'
        expect(comment.user.passive_notifications.first.comment).to eq other_comment
      end
    end
  end

  describe 'commentable => question' do
    include_examples 'コメント通知のテスト' do
      let!(:commentable) { create(:question) }
    end
  end

  describe 'commentable => post' do
    include_examples 'コメント通知のテスト' do
      let!(:commentable) { create(:post) }
    end
  end

  describe 'commentable => answer' do
    include_examples 'コメント通知のテスト' do
      let!(:commentable) { create(:answer) }
    end
  end
end
