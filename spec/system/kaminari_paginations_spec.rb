require 'rails_helper'

RSpec.describe "KaminariPaginations", type: :system do
  let(:user) { create(:user) }

  shared_examples 'ページネーションが機能していること' do
    example 'ページネーション部分が表示されていること' do
      expect(page).to have_selector '.pagination'
    end

    example '一ページあたりの表示数が正しいこと' do
      expect(page).to have_content object_text, count: object_counts
    end
  end

  describe 'questions#index' do
    before do
      create_list(:question, 11)
      visit questions_path
    end

    include_examples 'ページネーションが機能していること' do
      let(:object_text) { 'Title' }
      let(:object_counts) { 10 }
    end
  end

  describe 'stocks#index' do
    before do
      create_list(:stock, 11, user: user)
      visit user_stocks_path(user.id)
    end

    include_examples 'ページネーションが機能していること' do
      let(:object_text) { 'Title' }
      let(:object_counts) { 10 }
    end
  end

  pending 'posts/indexがActionController::UnknownFormatとなるため保留' do
    describe 'posts/index' do
      before do
        create_list(:post, 11, user: user)
        visit posts_path(user.id)
      end

      include_examples 'ページネーションが機能していること' do
        let(:object_text) { 'MyText' }
        let(:object_counts) { 10 }
      end
    end
  end
end
