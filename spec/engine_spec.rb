require_relative 'spec_helper'

describe 'Trading::Engine' do
  before do
    @engine = Trading::Engine.new
  end

  describe '#submit_order' do
    it "should return false for no match" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")

      @engine.submit_order(order).should eq(false)
    end

    it "should return a pair of orders for a match" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tBTC\t100.000")

      @engine.submit_order(buy).should eq(false)
      p @engine.order_book
      @engine.submit_order(sell).should eq([sell, buy])
    end

    it "should not match differing commodities" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tUSD\t100.000")

      @engine.submit_order(buy).should eq(false)
      @engine.submit_order(sell).should eq(false)
    end

    it "should not match differing amounts" do
      buy = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")
      sell = Trading::Order.parse("2013-12-01T16:20:00Z\tSELL\tBTC\t100.001")

      @engine.submit_order(buy).should eq(false)
      @engine.submit_order(sell).should eq(false)
    end

  end
end

