require 'algorithms'

class Trading::Engine

  attr_reader :order_book

  def initialize
    @order_book = {}
  end

  def submit_order(order)
    book = (order_book[order.commodity] ||= Trading::OrderBook.new)
    book.submit_order(order)
    if book.match?
      return book.trade!
    else
      return false
    end
  end
end
