class MerchantNameRevenueSerializer
  include JSONAPI::Serializer
  set_type :merchant_name_revenue
  attribute :name, :revenue
end
