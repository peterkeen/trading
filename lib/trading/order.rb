require 'time'

class Trading::Order

  attr_reader :time, :order_type, :price, :commodity
  attr_accessor :quantity

  def self.parse(line)
    parts = line.split(/\t/)
    self.new(
      :time => Time.parse(parts[0]),
      :order_type => parts[1].downcase.to_sym,
      :commodity => parts[2],
      :price => parts[3],
      :quantity => parts[4].to_i
    )
  end

  def initialize(opts={})
    @time = opts[:time]
    @order_type = opts[:order_type]
    @commodity = opts[:commodity]
    @price = opts[:price]
    @quantity = opts[:quantity]
  end

  def <=>(other)
    commodity_e = commodity <=> other.commodity
    return commodity_e if commodity_e != 0

    price_e = price <=> other.price
    return price_e if price_e != 0

    time_e = time <=> other.time
    return time_e
  end

  def to_s
    [time, order_type, price, commodity, quantity].join("\t")
  end

  def split(amount)
    if amount >= quantity
      raise "Invalid split: desired amount #{amount} greater than available amount #{quantity}"
    end

    new_order = dup
    new_order.quantity = amount
    self.quantity = self.quantity - amount

    new_order
  end

  def match?(other)

    price_match = if order_type == :buy && other.order_type == :sell
      price >= other.price
    else
      price <= other.price
    end
    
    commodity == other.commodity &&
      quantity == other.quantity &&
      price_match
  end

  private

  def match_order_type
    order_type == :buy ? :sell : :buy
  end

end
