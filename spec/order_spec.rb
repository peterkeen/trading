require_relative 'spec_helper'

describe "Trading::Order" do
  describe "#parse" do

    it "should parse a buy" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      order.order_type.should eq(:buy)
      order.commodity.should eq("BTC")
      order.price.should eq('100.000')
      order.time.should eq(Time.utc(2013,12,1,16,19))
      order.quantity.should eq(100)
    end

  end

  describe "comparision" do
    it "should compare commodities" do
      order1 = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      order2 = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tUSD\t100.000\t100")

      comp = order1 <=> order2
      comp.should eq -1
    end

    it "should compare prices" do
      order1 = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")
      order2 = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t101.000\t100")

      comp = order1 <=> order2
      comp.should eq -1
    end

    it "should compare timestamps" do
      order1 = Trading::Order.parse("2013-12-01T16:18:00Z\tBUY\tBTC\t100.000\t100")
      order2 = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000\t100")

      comp = order1 <=> order2
      comp.should eq -1
    end
  end

  describe "#match" do
    it "should match a corresponding order" do
      order1 = Trading::Order.parse("2013-12-01T16:18:00Z\tBUY\tBTC\t100.000\t100")
      order2 = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t100.000\t100")

      order1.match?(order2).should be_true
    end

    it "should not match a non-matching order" do
      order1 = Trading::Order.parse("2013-12-01T16:18:00Z\tBUY\tBTC\t100.000\t100")
      order2 = Trading::Order.parse("2013-12-01T16:19:00Z\tSELL\tBTC\t101.000\t100")

      order1.match?(order2).should be_false
    end
  end

  describe "#split" do
    it "should create a new order with the desired amount" do
      order = Trading::Order.parse("2013-12-01T16:18:00Z\tBUY\tBTC\t100.000\t100")

      new_order = order.split(50)

      new_order.should_not eq(order)
      new_order.quantity.should eq(50)
      order.quantity.should eq(50)
    end
  end
      
end
