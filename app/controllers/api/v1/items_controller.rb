class Api::V1::ItemsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 20)
    if params[:page].to_i > 0
      page =  per_page * (params.fetch(:page, 1).to_i - 1)
    else
      page = 0
    end
    items = Item.limit(per_page).offset(page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update

    item = Item.find(params[:id])
    Merchant.find(params[:merchant_id]) if params[:merchant_id]
    item.update(item_params)
    render json: ItemSerializer.new(item)
  end


  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  def find_all
    validate_params
    items = Item.find_all_by_name(params[:name])
    render json: ItemSerializer.new(items)
  end

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def validate_params
    raise ActionController::BadRequest if invalid_params?
  end

  def invalid_params?
    params[:name].nil? || params[:name].empty?
  end

end
