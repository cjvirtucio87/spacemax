class PurchasesController < ApplicationController

  def create
    @vehicles = ActiveSupport::JSON.decode params[:vehicles]
    name = purchase_params[:name]
    model = @vehicles[name]['model']
    manufacturer = @vehicles[name]['manufacturer']
    cost = @vehicles[name]['cost']
    @purchase = Purchase.new(name: name,
                             model: model,
                             manufacturer: manufacturer,
                             cost: cost)
    if @purchase.save
      flash[:success] = "Purchase successful."
    else
      flash[:danger] = "Error in purchase!"
    end
    redirect_to vehicles_path
  end

  private
    def purchase_params
      params.require(:purchase).permit(:name)
    end
end
