require 'rails_helper'

RSpec.describe 'Revenue Unshipped API' do
  context 'has merchants' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item1) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 300 }
    end
    let!(:invoice_item2) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 }
    end
    let!(:invoice_item3) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 3, unit_price: 50 }
    end
    let!(:invoice_item4) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice3.id, quantity: 3, unit_price: 50 }
    end

    let(:merchant2) { create :merchant }
    let!(:item21) { create :item, { merchant_id: merchant2.id } }
    let!(:invoice21) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice22) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice23) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice24) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item21) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice21.id, quantity: 1, unit_price: 300 }
    end
    let!(:invoice_item22) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 8, unit_price: 25 }
    end
    let!(:invoice_item23) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 3, unit_price: 100 }
    end
    let!(:invoice_item24) do
      create :invoice_item, { item_id: item21.id, invoice_id: invoice23.id, quantity: 3, unit_price: 200 }
    end

    let(:merchant3) { create :merchant }
    let!(:item31) { create :item, { merchant_id: merchant3.id } }
    let!(:invoice31) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice32) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice33) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice34) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item31) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice31.id, quantity: 1, unit_price: 300 }
    end
    let!(:invoice_item32) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 4, unit_price: 100 }
    end
    let!(:invoice_item33) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 3, unit_price: 150 }
    end
    let!(:invoice_item34) do
      create :invoice_item, { item_id: item31.id, invoice_id: invoice33.id, quantity: 3, unit_price: 150 }
    end

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice4.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice22.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice24.id } }
    let!(:trans5) { create :transaction, { result: 'success', invoice_id: invoice32.id } }
    let!(:trans6) { create :transaction, { result: 'success', invoice_id: invoice34.id } }
    let!(:trans7) { create :transaction, { result: 'failed', invoice_id: invoice1.id } }
    let!(:trans8) { create :transaction, { result: 'success', invoice_id: invoice3.id } }
    let!(:trans9) { create :transaction, { result: 'success', invoice_id: invoice23.id } }
    let!(:trans0) { create :transaction, { result: 'success', invoice_id: invoice33.id } }

    it 'returns results for potential unshipped revenue' do
      get '/api/v1/revenue/unshipped?quantity=2'

      expect(response).to be_successful

      merchant_data = JSON.parse(response.body, symbolize_names: true)
      first_merchant_data = merchant_data[:data].first

      expect(merchant_data[:data].size).to eq(2)
      expect(first_merchant_data[:attributes][:potential_revenue]).to eq(600.0)
    end

    it 'gives an error if id is wrong' do
      get '/api/v1/revenue/merchants/123123123231434153'

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end
end
