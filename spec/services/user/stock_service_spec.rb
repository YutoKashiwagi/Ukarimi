require 'rails_helper'

RSpec.describe "User::StockService", type: :service do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let(:user_stock_service) { User::StockService.new(user, question) }

  describe 'stock' do
    context 'ストックしていない場合' do
      example 'ストックできること' do
        expect do
          user_stock_service.stock
        end.to change(Stock, :count).by(1)
      end
    end

    context 'ストックしている場合' do
      before { user.stocked_questions << question }

      example '再度ストックするとnilを返すこと' do
        expect(user_stock_service.stock).to eq nil
      end
    end
  end

  describe 'unstock' do
    context 'ストックしていない場合' do
      example 'ストック解除するとnilを返すこと' do
        expect(user_stock_service.unstock).to eq nil
      end
    end

    context 'ストックしている場合' do
      before { user.stocked_questions << question }

      example 'ストック解除できること' do
        expect do
          user_stock_service.unstock
        end.to change(Stock, :count).by(-1)
      end
    end
  end
end
