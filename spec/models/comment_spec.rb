require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:comment) { build(:comment, user: user, commentable: question) }

  example '有効なファクトリを持つこと' do
    expect(comment.valid?).to eq true
    comment.commentable = answer
    expect(comment.valid?).to eq true
  end

  describe 'バリデーション' do
    example 'userがいなければいけないこと' do
      comment.user = nil
      comment.valid?
      expect(comment.errors[:user]).to include('must exist')
    end

    example 'commentableがなければならないこと' do
      comment.commentable = nil
      comment.valid?
      expect(comment.errors[:commentable]).to include('must exist')
    end

    example 'contentが空白ではいけないこと' do
      comment.content = ''
      comment.valid?
      expect(comment.errors[:content]).to include("can't be blank")
    end

    describe 'contentの文字数' do
      example '1000文字以下' do
        comment.content = 'a' * 1000
        expect(comment.valid?).to eq true
      end

      example '1001文字以上' do
        comment.content = 'a' * 1001
        comment.valid?
        expect(comment.errors[:content]).to include('is too long (maximum is 1000 characters)')
      end
    end
  end

  describe 'dependent: :destroy' do
    example 'questionに紐づいて削除されること' do
      comment.save
      expect { question.destroy }.to change(Comment, :count).by(-1)
    end

    example 'answerに紐づいて削除されること' do
      comment.commentable = answer
      comment.save
      expect { answer.destroy }.to change(Comment, :count).by(-1)
    end

    example 'userに紐づいて削除されること' do
      comment.save
      expect { user.destroy }.to change(Comment, :count).by(-1)
    end
  end
end
