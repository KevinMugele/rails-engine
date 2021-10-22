require 'rails_helper'

RSpec.describe 'api/v1/merchants#index' do
  describe 'happy path' do
    it 'sends a list of merchants' do
      create_list(:merchant, 20)

      get api_v1_merchants_path
      # get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      merchants.each do |merchant|
        expect(merchant).to have_key("id")
        expect(merchant["id"]).to be_an(Integer)

        expect(merchant).to have_key("name")
        expect(merchant["name"]).to be_a(String)
      end
    end
  end
end
