require 'rails_helper'

RSpec.describe 'Items Merchants Api' do
  it 'can get one merchant' do
    merchant = create(:merchant)
    merchant_items = create_list(:item, 15, merchant: merchant)
    id = Item.last.id

    get "/api/v1/items/#{id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes]).to_not have_key(:created_at)
    expect(merchant[:data][:attributes]).to_not have_key(:updated_at)
  end
end
