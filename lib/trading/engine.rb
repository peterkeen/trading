require 'algorithms'

class Trading::Engine

  attr_reader :order_book

  def initialize
    @order_book = {}
    @observers = []
  end

  def submit_order(order)
    notify_observers(:order, order)

    book = (order_book[order.commodity] ||= Trading::OrderBook.new)
    book.submit_order(order)
    if book.match?
      trade = book.trade!
      notify_observers(:trade, trade)
    end
  end

  def add_observer(observer)
    @observers << observer
  end

  private

  def notify_observers(event, payload)
    @observers.each do |observer|
      observer.send(event, payload)
    end
  end

end
