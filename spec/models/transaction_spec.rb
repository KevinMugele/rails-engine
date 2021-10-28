require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
  end

  describe 'validations' do
    it { should validate_presence_of(:result) }
  end

  describe 'scopes' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 100 } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 } }
    let!(:invoice_item3) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 3, unit_price: 150 } }

    let(:merchant2) { create :merchant }
    let!(:item21) { create :item, { merchant_id: merchant2.id } }
    let!(:invoice21) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice22) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice23) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice24) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item21) { create :invoice_item, { item_id: item21.id, invoice_id: invoice21.id, quantity: 1, unit_price: 100 } }
    let!(:invoice_item22) { create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 2, unit_price: 20 } }
    let!(:invoice_item23) { create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 3, unit_price: 1 } }

    let(:merchant3) { create :merchant }
    let!(:item31) { create :item, { merchant_id: merchant3.id } }
    let!(:invoice31) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice32) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice33) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice34) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item31) { create :invoice_item, { item_id: item31.id, invoice_id: invoice31.id, quantity: 1, unit_price: 500 } }
    let!(:invoice_item32) { create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 4, unit_price: 100 } }
    let!(:invoice_item33) { create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 2, unit_price: 250 } }

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice4.id } }
    let!(:trans7) { create :transaction, { result: 'failed', invoice_id: invoice1.id } }

    it 'has a scope of success' do
      expect(Transaction.success).to eq([trans1, trans2])
    end
  end
end
