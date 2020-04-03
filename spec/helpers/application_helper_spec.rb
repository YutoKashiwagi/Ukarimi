require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper
  describe 'full_titleメソッド' do
    context '引数なしの場合' do
      example 'base titleを返すこと' do
        expect(full_title('')).to eq 'Ukarimi'
      end
    end

    context '引数ありの場合' do
      example 'full titleを返すこと' do
        expect(full_title('hoge')).to eq 'hoge | Ukarimi'
      end
    end
  end
end
