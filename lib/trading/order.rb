require 'time'

class Trading::Order

  attr_reader :time, :order_type, :price, :commodity

  def self.parse(line)
    parts = line.split(/\t/)
    self.new(
      :time => Time.parse(parts[0]),
      :order_type => parts[1].downcase.to_sym,
      :commodity => parts[2],
      :price => parts[3]
    )
  end

  def initialize(opts={})
    @time = opts[:time]
    @order_type = opts[:order_type]
    @commodity = opts[:commodity]
    @price = opts[:price]
  end

  def to_match_key
    "#{match_order_type.to_s.upcase}-#{commodity}-#{price}"
  end

  def to_hash_key
    "#{order_type.to_s.upcase}-#{commodity}-#{price}"
  end

  private

  def match_order_type
    order_type == :buy ? :sell : :buy
  end
  
end
