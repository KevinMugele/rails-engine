class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 20)
    if params[:page].to_i > 0
      page =  per_page * (params.fetch(:page, 1).to_i - 1)
    else
      page = 0
    end
    merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find
    validate_params
    merchant = Merchant.find_by_name(params[:name])
    render json: MerchantSerializer.new(merchant)
  end

  def find_all
    validate_params
    merchants = Merchant.find_all_by_name(params[:name])
    render json: MerchantSerializer.new(merchants)
  end

  def most_items
    validate_quantity_params
    merchants = Merchant.most_items_sold(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end

private
  def validate_params
    raise ActionController::BadRequest unless valid_params?
  end

  def validate_quantity_params
    raise ActionController::BadRequest unless valid_quantity_params?
  end

  def valid_params?
    params[:name]&.present?
  end

  def valid_quantity_params?
    params[:quantity]&.to_i&.positive?
  end
end
