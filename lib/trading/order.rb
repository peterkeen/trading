require 'time'

class Trading::Order

  attr_reader :time, :order_type, :price, :commodity

  def initialize(opts={})
    @time = opts[:time]
    @order_type = opts[:order_type]
    @commodity = opts[:commodity]
    @price = opts[:price]
  end
  
  def self.parse(line)
    parts = line.split(/\t/)
    self.new(
      :time => Time.parse(parts[0]),
      :order_type => parts[1].downcase.to_sym,
      :commodity => parts[2],
      :price => parts[3]
    )
  end
end
