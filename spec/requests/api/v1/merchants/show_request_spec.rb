require 'rails_helper'

describe 'merchants API' do
  it 'can get one merchant' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes]).to_not have_key(:created_at)
    expect(merchant[:data][:attributes]).to_not have_key(:updated_at)
  end

  it 'has 404 error if bad id' do
    create(:merchant)

    get "/api/v1/merchants/2"

    expect(response).to_not be_successful
    expect(response).to have_http_status(404)
  end
end
