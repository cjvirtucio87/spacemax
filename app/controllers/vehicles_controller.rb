class VehiclesController < ApplicationController

  class SwapiInterface
    #Equivalent to class.extend(HTTParty)
    include HTTParty
    
    class << self

      VEHICLES_URI = ENV['TARGET_URI']

      def get_request(page=1)
        get(VEHICLES_URI, query: { page: page })
      end

      def all_vehicles
        vehicles = {}
        curr = get(VEHICLES_URI)
        until curr['next'].nil?
          curr['results'].each do |result|
            vehicles[result['name']] = { 'model' => result['model'],
                                         'manufacturer' => result['manufacturer'],
                                         'cost' => result['cost_in_credits'] }
          end
          curr = get(curr['next'])
        end
        vehicles
      end

    end

  end

  def index
    if params[:vehicles]
      @vehicles = ActiveSupport::JSON.decode(params[:vehicles])
    else
      @vehicles = SwapiInterface.all_vehicles
    end
    @credits = session['credits'] ||= 1000000
  end

  def show
    name = params[:vehicle]
    @vehicles = ActiveSupport::JSON.decode params[:vehicles]
    @vehicle = { name: name,
                 model: @vehicles[name]['model'],
                 manufacturer: @vehicles[name]['manufacturer'],
                 cost: @vehicles[name]['cost'] }
    render :show
  end

  private
    def option_param
      params.require(:vehicles).permit(:option)
    end
end
