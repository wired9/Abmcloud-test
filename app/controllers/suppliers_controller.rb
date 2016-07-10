class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all.page(params[:page])
  end
end
