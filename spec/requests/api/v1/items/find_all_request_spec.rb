require 'rails_helper'

RSpec.describe 'Items Find ALL API' do
  it 'allows you to search for a single item' do
    item1 = create(:item, name: "AAA")
    item2 = create(:item, name: "BBB")
    item3 = create(:item, name: "CCC")
    item4 = create(:item, name: "DDD")
    item5 = create(:item, name: "EEE")
    item5 = create(:item, name: "BBE")

    get "/api/v1/items/find_all?name=BB"

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
      expect(item[:attributes]).to_not have_key(:created_at)
      expect(item[:attributes]).to_not have_key(:updated_at)
    end
  end

  it 'gives an error if parameter is missing' do
    get "/api/v1/items/find_all"

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
  end

  it 'gives an error if parameter is empty' do
    get "/api/v1/items/find_all?name="

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
  end
end
