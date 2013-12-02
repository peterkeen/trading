require 'algorithms'

class Trading::OrderBook
  attr_accessor :buy_map, :sell_map

  def initialize
    @buy_map = Containers::CRBTreeMap.new
    @sell_map = Containers::CRBTreeMap.new
  end

  def submit_order(order)
    if order.order_type == :buy
      buy_map.push(order, true)
    else
      sell_map.push(order, true)
    end
  end

  def match?
    return false if buy_map.size == 0 || sell_map.size == 0
    sell_map.min_key.match? buy_map.max_key
  end

  def trade!
    sell = sell_map.max_key
    buy = buy_map.min_key

    sell_map.delete(sell)
    buy_map.delete(buy)

    return Trading::Trade.new(buy, sell)
  end
end
