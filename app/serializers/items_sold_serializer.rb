class ItemsSoldSerializer
  include JSONAPI::Serializer

  attribute :name
  attribute :count do |object|
    object.item_count
  end 
end
