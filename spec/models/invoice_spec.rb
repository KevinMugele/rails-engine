require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'instance methods' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice5) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice_item1) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 100 }
    end
    let!(:invoice_item2) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 }
    end
    let!(:invoice_item3) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice3.id, quantity: 3, unit_price: 150 }
    end
    let!(:invoice_item3) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice5.id, quantity: 3, unit_price: 150 }
    end
    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice4.id } }

    it 'has a shipped scope' do
      expect(Invoice.shipped).to eq([invoice2, invoice4])
    end

    it '#considered_revenue' do
      expect(Invoice.considered_revenue).to eq([invoice2, invoice4])
    end

    it '#unshipped_order_revenue' do
      expect(Invoice.unshipped_order_revenue(1)).to eq([invoice5])
    end
  end
end
