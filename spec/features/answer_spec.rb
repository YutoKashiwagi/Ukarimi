require 'rails_helper'

RSpec.feature "Answers", type: :feature do
  include Warden::Test::Helpers
  subject { page }

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before do
    login_as user, scope: :user
    visit question_path(question.id)
  end

  it '正常に回答できること' do
    fill_in 'answer[content]', with: ' 正しい回答'
    click_button '回答する'
    is_expected.to have_content '正しい回答'
  end

  it 'presence: true' do
    fill_in 'answer[content]', with: ''
    click_button '回答する'
    is_expected.to have_content '回答に失敗しました'
  end

  it 'length: { maximum: 1000 }' do
    fill_in 'answer[content]', with: 'a' * 1001
    click_button '回答する'
    is_expected.to have_content '回答に失敗しました'
  end
end
