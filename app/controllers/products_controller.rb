class ProductsController < ApplicationController

  respond_to :html, :json

  def index
    @products = Product.saled.where(type_id: params[:type_id])
    respond_with(@products)
  end
  
  def search
    @products = Product.saled.search(params[:q])
    unless params[:type_id].blank?
      @products = @products.where(type_id: params[:type_id])
    end
    render :index
  end

  def show
    respond_with(@product)
  end

end