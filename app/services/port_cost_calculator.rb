class PortCostCalculator < OpenStruct
  def initialize(params = {})
    [[:status, 200], [:cost, nil]].each { |p, v| params[p] = v }
    [:included, :optional].each { |p| params[p] = [] }
    super(params)
  end

  def call
    validate
    calculate if valid?
    prepare_options if valid?
    self
  end

  def valid?
    status == 200
  end

  def as_json(_ = {})
    {
      status: status,
      cost: cost,
      currency: port.currency,
      included: included,
      optional: optional,
      additional_info: port.additional_info
    }
  end

  private

  def validate
    self.status = 465 if yacht.nil?
  end

  def calculate
    yacht_cost = calculate_yacht_cost
    crew_cost = calculate_crew_cost
    self.cost = yacht_cost + crew_cost unless yacht_cost.nil?
  end

  def calculate_crew_cost
    port.price_per_person * yacht.crew
  end

  def calculate_yacht_cost
    port.yacht_size_range_prices.each do |range|
      return range.price if proper_length?(range) && proper_width?(range)
    end
    self.status = 464
    nil
  end

  def proper_length?(range)
    (range.min_length..range.max_length).include?(yacht.length)
  end

  def proper_width?(range)
    yacht.width < range.max_width
  end

  def prepare_options
    %w(power_connection wc shower washbasin dishes wifi parking
       emptying_chemical_toilet).each do |opt|
      add_option(opt) if port.public_send("has_#{opt}")
    end
  end

  def add_option(opt)
    container = (port.public_send("price_#{opt}").zero? ? included : optional)
    container << { name: opt, price: port.public_send("price_#{opt}") }
  end
end
