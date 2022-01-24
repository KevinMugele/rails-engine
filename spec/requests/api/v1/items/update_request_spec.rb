require 'rails_helper'

describe 'update item API' do
  it 'updates item' do
    merchant = create(:merchant)
    merchant_items = create_list(:item, 15, merchant: merchant)
    id = Item.last.id
    previous_name = Item.last.name
    item_params = {
      name: 'lamp'
    }
    headers = { "CONTENT_TYPE": 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find_by(id: id)

    expect(response).to be_successful

    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('lamp')
  end
end
