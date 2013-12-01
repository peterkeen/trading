class Trading::Engine

  attr_reader :order_book
  def initialize
    @order_book = {}
  end

  def submit_order(order)
    match_key = order.to_match_key

    if (@order_book[match_key] || []).length == 0
      @order_book[order.to_hash_key] ||= []
      @order_book[order.to_hash_key] << order
      return false
    else
      match = @order_book[match_key].pop
      return [order, match]
    end
  end
end
