class Trading::Trade

  attr_reader :buy, :sell

  def initialize(buy, sell)
    @buy = buy
    @sell = sell
  end

  def price
    if @buy.time > @sell.time
      @buy.price
    else
      @sell.price
    end
  end

  def to_s
    [
      @buy.commodity,
      price,
      @buy.time,
      @sell.time
    ].join("\t")
  end

  def ==(other)
    buy == other.buy && sell == other.sell
  end
end
