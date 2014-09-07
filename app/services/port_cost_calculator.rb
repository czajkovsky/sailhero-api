class PortCostCalculator
  attr_reader :yacht, :port, :total_cost, :messages

  def initialize(yacht, port)
    @yacht = yacht
    @port = port
    @messages = []
    @total_cost = calculate_cost
  end

  def calculate_cost
    calculate_crew_cost + calculate_yacht_cost + calculate_options_cost
  end

  def calculate_crew_cost
    port.price_per_person * yacht.crew
  end

  def calculate_yacht_cost
    port.yacht_size_range_prices.each do |range|
      return range.price if proper_length?(range) && proper_width?(range)
    end
    @messages << I18n.t('port_cost_calculator.errors.no_place_available')
  end

  def proper_length?(range)
    (range.min_length..range.max_length).include?(yacht.length)
  end

  def proper_width?(range)
    yacht.width < range.max_width
  end

  def calculate_options_cost
    0
  end
end
