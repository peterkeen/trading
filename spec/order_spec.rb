require_relative 'spec_helper'

describe "Trading::Order" do
  describe "#parse" do

    it "should parse a buy" do
      order = Trading::Order.parse("2013-12-01T16:19:00Z\tBUY\tBTC\t100.000")
      order.order_type.should eq(:buy)
      order.commodity.should eq("BTC")
      order.price.should eq('100.000')
      order.time.should eq(Time.utc(2013,12,1,16,18))
    end

  end
end
