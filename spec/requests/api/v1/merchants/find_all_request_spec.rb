require 'rails_helper'

RSpec.describe 'Merchants Find ALL API' do
  it 'allows you to search for a single merchant' do
    merchant1 = create(:merchant, name: "AAA")
    merchant2 = create(:merchant, name: "BBB")
    merchant3 = create(:merchant, name: "CCC")
    merchant4 = create(:merchant, name: "DDD")
    merchant5 = create(:merchant, name: "EEE")
    merchant5 = create(:merchant, name: "BBE")

    get "/api/v1/merchants/find_all?name=BB"

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

  it 'gives an error if parameter is missing' do
    merchant1 = create(:merchant, name: "AAA")
    merchant2 = create(:merchant, name: "BBB")
    merchant3 = create(:merchant, name: "CCC")
    merchant4 = create(:merchant, name: "DDD")
    merchant5 = create(:merchant, name: "EEE")

    get "/api/v1/merchants/find_all"

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
  end

  it 'gives an error if parameter is empty' do
    merchant1 = create(:merchant, name: "AAA")
    merchant2 = create(:merchant, name: "BBB")
    merchant3 = create(:merchant, name: "CCC")
    merchant4 = create(:merchant, name: "DDD")
    merchant5 = create(:merchant, name: "EEE")

    get "/api/v1/merchants/find_all?name="

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
  end
end
