require_relative 'spec_helper'

describe "Trading::Order" do
  describe "#parse" do

    it "should parse a buy" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")
      order.order_type.should eq(:buy)
      order.commodity.should eq("BTC")
      order.price.should eq('100.000')
      order.time.should eq(Time.utc(2013,12,1,16,19))
    end

  end

  describe "#to_match_key" do

    it "should create a matching string" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")

      order.to_match_key.should eq("SELL-BTC-100.000")
    end

  end

  describe "#to_hash_key" do
    it "should create a hash key" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")

      order.to_hash_key.should eq("BUY-BTC-100.000")
    end
  end
      
end
