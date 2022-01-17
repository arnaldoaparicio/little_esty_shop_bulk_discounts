class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show 
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create 
    bulk_discount = BulkDiscount.new(discount_params)
    bulk_discount.save
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy 
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private 

  def discount_params
    params.permit(:percentage, :threshold, :merchant_id)
  end
end
