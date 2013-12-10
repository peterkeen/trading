require_relative 'spec_helper'

describe 'Trading::Engine' do
  before do
    @engine = Trading::Engine.new
    @observer = TestObserver.new
    @engine.add_observer @observer
  end

  describe '#submit_order' do
    it "should return false for no match" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")

      @engine.submit_order(order)
      @observer.trades.length.should eq(0)
    end

    it "should return a pair of orders for a match" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tBTC\t100.000\t100")

      @engine.submit_order(buy)
      @observer.trades.length.should eq(0)

      @engine.submit_order(sell)
      @observer.trades.length.should eq(1)
      @observer.trades.first.should eq(Trading::Trade.new(buy, sell))
    end

    it "should not match differing commodities" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tUSD\t100.000\t100")

      @engine.submit_order(buy)
      @observer.trades.length.should eq(0)
      @engine.submit_order(sell)
      @observer.trades.length.should eq(0)
    end

    it "should not match differing prices" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tBTC\t100.001\t100")

      @engine.submit_order(buy)
      @observer.trades.length.should eq(0)
      @engine.submit_order(sell)
      @observer.trades.length.should eq(0)
    end

    it "should not match differing quantities" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tBTC\t100.000\t200")

      @engine.submit_order(buy)
      @observer.trades.length.should eq(0)
      @engine.submit_order(sell)
      @observer.trades.length.should eq(0)
    end
  end
end
