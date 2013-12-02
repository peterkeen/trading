require_relative 'spec_helper'

describe "Trading::OrderBook" do

  before do
    @book = Trading::OrderBook.new
  end
  
  describe "#submit_order" do
    it "should push the order onto the buy book" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")

      @book.submit_order(buy)

      @book.buy_map.size.should eq(1)
      @book.sell_map.size.should eq(0)
    end

    it "should push the order onto the sell book" do
      sell = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t100.000\t100")

      @book.submit_order(sell)

      @book.sell_map.size.should eq(1)
      @book.buy_map.size.should eq(0)
    end
  end

  describe "#match?" do
    it "should return false if buy is empty" do
      sell = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t100.000\t100")

      @book.submit_order(sell)

      @book.match?.should be_false
    end

    it "should return false if sell is empty" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")

      @book.submit_order(buy)

      @book.match?.should be_false
    end

    it "should return false if sell does not match buy" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t100.000\t200")

      @book.submit_order(buy)
      @book.submit_order(sell)

      @book.match?.should be_false
    end

    it "should return true if sell matches buy" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t100.000\t100")

      @book.submit_order(buy)
      @book.submit_order(sell)

      @book.match?.should be_true
    end
  end

  describe "#trade!" do
    it "should remove the top-most buy and sell keys" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      buy2 = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t101.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t100.000\t100")

      @book.submit_order(buy)
      @book.submit_order(buy2)
      @book.submit_order(sell)

      @book.trade!.should eq([buy, sell])

      @book.buy_map.size.should eq(1)
      @book.sell_map.size.should eq(0)
    end
  end
end
