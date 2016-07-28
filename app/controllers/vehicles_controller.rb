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
        vehicles = []
        curr = get(VEHICLES_URI)
        until curr['next'].nil?
          vehicles << curr['results'].map do |result|
            [result['name'],result['model'],result['manufacturer']]
          end
          curr = get(curr['next'])
        end
        vehicles
      end

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
  end

  private

    def option_param
      params.require(:vehicles).permit(:option)
    end
end
