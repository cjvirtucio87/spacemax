class VehiclesController < ApplicationController

  class SwapiInterface
    # HTTParty gets included in the class, which means
    # that its singleton class is extended. Therefore,
    # you can just call methods directly in the singleton class.
    include HTTParty
    
    class << self

      VEHICLES_URI = ENV['TARGET_URI']

      def get_request(page=1)
        get(VEHICLES_URI, query: { page: page })
      end

      def all_vehicles
        # vehicles = []
        # curr = get(VEHICLES_URI)
        # until curr['next'].nil?
        #   curr['results'].each do |result|
        #     vehicles.push result['name']
        #   end
        #   curr = get(curr['next'])
        # end
        # vehicles
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

      # def get_vehicle_details(vehicle)

      # end

    end

  end

# until curr['next'].nil?
#   @vehicles << curr['results'].map { |result| [result['name'],result['model']] }
#   curr = SwapiInterface.get_vehicles(curr['next'])
# end

  def index
    @vehicles = SwapiInterface.all_vehicles
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
