class SkusController < ApplicationController
  def index
    @skus = SKU.order(:id).page(params[:page])
  end
end
