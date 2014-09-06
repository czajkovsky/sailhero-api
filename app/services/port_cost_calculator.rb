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
    0
  end

  def calculate_options_cost
    0
  end
end
