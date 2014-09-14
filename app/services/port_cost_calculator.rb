class PortCostCalculator < Response
  attr_reader :yacht, :port
  attr_accessor :total_cost, :included, :optional, :messages, :available

  def initialize(params = {})
    super
    @yacht = params.fetch(:yacht)
    @port = params.fetch(:port)
    calculate
  end

  def calculate
    @included, @optional = [], []
    @available = true
    set_options
    @total_cost = calculate_crew_cost + calculate_yacht_cost
  end

  def calculate_crew_cost
    port.price_per_person * yacht.crew
  end

  def calculate_yacht_cost
    port.yacht_size_range_prices.each do |range|
      return range.price if proper_length?(range) && proper_width?(range)
    end
    add_message('pc501_no_place_available')
    @available = false
    0
  end

  def proper_length?(range)
    (range.min_length..range.max_length).include?(yacht.length)
  end

  def proper_width?(range)
    yacht.width < range.max_width
  end

  def set_options
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
    available ? available_hash : unavailable_hash
  end

  def available_hash
    { cost: total_cost, messages: messages, included: included,
      optional: optional }
  end

  def unavailable_hash
    { cost: '---', messages: messages }
  end
end
