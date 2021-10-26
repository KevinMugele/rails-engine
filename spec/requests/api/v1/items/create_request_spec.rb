require 'rails_helper'

describe 'items create API' do
  it 'can create an item' do
    merchant = create(:merchant)
    headers = {"CONTENT_TYPE": "application/json"}
    item_params =      ( {
        name: 'lamp',
        description: 'light',
        unit_price: 49.99,
        merchant_id: merchant.id
      })

    post "/api/v1/items/", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:attributes][:name]).to eq(item_params[:name])
    expect(item[:data][:attributes][:description]).to eq(item_params[:description])
    expect(item[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])
    expect(item[:data][:attributes]).to_not have_key(:created_at)
    expect(item[:data][:attributes]).to_not have_key(:updated_at)
  end
end
