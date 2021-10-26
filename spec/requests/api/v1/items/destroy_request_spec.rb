require 'rails_helper'

describe 'delete item API' do
  it 'deletes an item' do
    merchant = create(:merchant)
    merchant_item = create_list(:item, 1, merchant: merchant)
    id = Item.last.id
    expect(Item.count).to eq(1)

    headers = {"CONTENT_TYPE": "application/json"}

    delete "/api/v1/items/#{id}", headers: headers

    expect(response).to be_successful

    expect(Item.count).to eq(0)
    expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
