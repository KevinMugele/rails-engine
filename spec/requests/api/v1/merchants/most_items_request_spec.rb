require 'rails_helper'

RSpec.describe 'Merchants Most Items Sold API' do
  context 'has merchants and items' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item100) { create :item, { merchant_id: merchant.id } }
    let!(:item90) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item1) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 100 }
    end
    let!(:invoice_item2) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 }
    end
    let!(:invoice_item3) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 3, unit_price: 150 }
    end

    let(:merchant2) { create :merchant }
    let!(:item21) { create :item, { merchant_id: merchant2.id } }
    let!(:item99) { create :item, { merchant_id: merchant.id } }
    let!(:item91) { create :item, { merchant_id: merchant.id } }
    let!(:invoice21) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice22) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice23) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice24) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item21) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice21.id, quantity: 1, unit_price: 100 }
    end
    let!(:invoice_item22) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 2, unit_price: 20 }
    end
    let!(:invoice_item23) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 3, unit_price: 1 }
    end

    let(:merchant3) { create :merchant }
    let!(:item31) { create :item, { merchant_id: merchant3.id } }
    let!(:item32) { create :item, { merchant_id: merchant.id } }
    let!(:item33) { create :item, { merchant_id: merchant.id } }
    let!(:invoice31) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice32) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice33) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice34) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item31) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice31.id, quantity: 1, unit_price: 500 }
    end
    let!(:invoice_item32) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 4, unit_price: 100 }
    end
    let!(:invoice_item33) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 2, unit_price: 250 }
    end

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice4.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice22.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice24.id } }
    let!(:trans5) { create :transaction, { result: 'success', invoice_id: invoice32.id } }
    let!(:trans6) { create :transaction, { result: 'success', invoice_id: invoice34.id } }
    let!(:trans7) { create :transaction, { result: 'failed', invoice_id: invoice1.id } }

    it 'allows you to search for a single merchant' do
      get '/api/v1/merchants/most_items?quantity=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants[:data]).to be_an(Array)
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes]).to_not have_key(:created_at)
        expect(merchant[:attributes]).to_not have_key(:updated_at)
      end
    end
  end
end
