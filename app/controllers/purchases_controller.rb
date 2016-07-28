class PurchasesController < ApplicationController

  def create
    @vehicles = ActiveSupport::JSON.decode params[:vehicles]
    @name = purchase_params[:name]
    @model = @vehicles[@name]['model']
    @manufacturer = @vehicles[@name]['manufacturer']
    @cost = @vehicles[@name]['cost'].to_i
    check_credits
  end

  private
    def purchase_params
      params.require(:purchase).permit(:name)
    end

    def check_credits
      if session['credits'] < @cost
        flash[:danger] = "Insufficient credits."
        @credits = session['credits']
        render 'vehicles/index'
      else
        @purchase = Purchase.new(name: @name,
                                 model: @model,
                                 manufacturer: @manufacturer,
                                 cost: @cost)
        save_purchase
        render 'vehicles/index'
      end
    end

    def save_purchase
      if @purchase.save
        flash.now[:success] = "Purchase successful."
        session['credits'] -= @cost
        @credits = session['credits']
      else
        flash.now[:danger] = "Error in purchase!"
      end
    end
end
