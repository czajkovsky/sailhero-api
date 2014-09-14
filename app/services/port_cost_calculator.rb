class PortCostCalculator
  attr_reader :yacht, :port, :total_cost, :messages, :included, :optional

  def initialize(yacht, port)
    @yacht = yacht
    @port = port
    @messages = []
    @included = []
    @optional = []
    options
    @total_cost = calculate_cost
  end

  def calculate_cost
    calculate_crew_cost + calculate_yacht_cost
  end

  def calculate_crew_cost
    port.price_per_person * yacht.crew
  end

  def calculate_yacht_cost
    port.yacht_size_range_prices.each do |range|
      return range.price if proper_length?(range) && proper_width?(range)
    end
    @messages << I18n.t('port_cost_calculator.errors.no_place_available')
    0
  end

  def proper_length?(range)
    (range.min_length..range.max_length).include?(yacht.length)
  end

  def proper_width?(range)
    yacht.width < range.max_width
  end

  def options
    %w(power_connection wc shower washbasin dishes wifi parking
       emptying_chemical_toilet).each do |opt|
      add_option(opt) if port.public_send("has_#{opt}")
    end
  end

  def add_option(opt)
    if port.public_send("price_#{opt}").zero?
      included << opt
    else
      optional << { name: opt, price: port.public_send("price_#{opt}") }
    end
  end

  def serialize
    {
      cost: total_cost,
      messages: messages,
      included: included,
      optional: optional
    }
  end
end
