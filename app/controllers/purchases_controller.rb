class PurchasesController < ApplicationController

  def create
    @vehicles = ActiveSupport::JSON.decode params[:vehicles]
    name = purchase_params[:name]
    model = @vehicles[name]['model']
    manufacturer = @vehicles[name]['manufacturer']
    cost = @vehicles[name]['cost']
    if session['credits'] < cost.to_i
      flash[:danger] = "Insufficient credits."
      redirect_to vehicles_path
    else
      @purchase = Purchase.new(name: name,
                               model: model,
                               manufacturer: manufacturer,
                               cost: cost)
      if @purchase.save
        flash.now[:success] = "Purchase successful."
        session['credits'] -= cost.to_i
        @credits = session['credits']
        @price = cost.to_i
      else
        flash.now[:danger] = "Error in purchase!"
      end
      render 'vehicles/index'
    end
  end

  private
    def purchase_params
      params.require(:purchase).permit(:name)
    end
end
