require 'rails_helper'

describe 'merchants items API' do
  it 'can get one merchant' do
    merchant = create(:merchant)
    merchant_items = create_list(:item, 15, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
    expect(items[:data]).to be_an(Array)
    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes]).to_not have_key(:created_at)
      expect(item[:attributes]).to_not have_key(:updated_at)
    end
  end

  it 'has 404 error if bad id' do
    create(:merchant)

    get "/api/v1/merchants/2"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end
end
