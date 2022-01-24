require 'rails_helper'

RSpec.describe 'Merchants Find API' do
  it 'allows you to search for a single merchant' do
    merchant1 = create(:merchant, name: 'AAA')
    merchant2 = create(:merchant, name: 'BBB')
    merchant3 = create(:merchant, name: 'CCC')
    merchant4 = create(:merchant, name: 'DDD')
    merchant5 = create(:merchant, name: 'EEE')

    get '/api/v1/merchants/find?name=BB'

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes]).to_not have_key(:created_at)
    expect(merchant[:data][:attributes]).to_not have_key(:updated_at)
  end

  it 'gives an error if parameter is missing' do
    merchant1 = create(:merchant, name: 'AAA')
    merchant2 = create(:merchant, name: 'BBB')
    merchant3 = create(:merchant, name: 'CCC')
    merchant4 = create(:merchant, name: 'DDD')
    merchant5 = create(:merchant, name: 'EEE')

    get '/api/v1/merchants/find'

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
  end

  it 'gives an error if parameter is empty' do
    merchant1 = create(:merchant, name: 'AAA')
    merchant2 = create(:merchant, name: 'BBB')
    merchant3 = create(:merchant, name: 'CCC')
    merchant4 = create(:merchant, name: 'DDD')
    merchant5 = create(:merchant, name: 'EEE')

    get '/api/v1/merchants/find?name='

    expect(response).to_not be_successful
    expect(response).to have_http_status(400)
  end
end
