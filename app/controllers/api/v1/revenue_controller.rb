class Api::V1::RevenueController < ApplicationController
  def index
    validate_params
    merchants = Merchant.top_merchants_by_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end

  def unshipped
    results = Invoice.unshipped_order_revenue(params[:quantity])
    render json: UnshippedOrderSerializer.new(results)
  end

private
  def validate_params
    raise ActionController::BadRequest if invalid_params?
  end

  def invalid_params?
    params[:quantity].nil? || params[:quantity].empty?
  end
end
