require 'spec_helper'

describe Matching::Order do

  context "initialize" do
    it "should throw invalid order error for empty attributes" do
      expect {
        Matching::Order.new({})
      }.to raise_error(Matching::InvalidOrderError)
    end

    it "should throw invalid order error given no volume" do
      expect {
        Matching.mock_order(type: :bid, volume: 0)
      }.to raise_error(Matching::InvalidOrderError)
    end

    it "should initialize market" do
        Matching.mock_order(type: :bid).market.should be_instance_of(Market)
    end
  end

  context "spaceship operator" do
    it "should sort by [price asc, timestamp asc]" do
      o1 = Matching.mock_order(type: :ask, price: 30, timestamp: 20.seconds.ago)
      o2 = Matching.mock_order(type: :ask, price: 30, timestamp: 10.seconds.ago)
      o3 = Matching.mock_order(type: :ask, price: 20, timestamp: 10.seconds.ago)

      [o1, o2, o3].sort.should == [o3, o1, o2]
    end
  end

  context "crossed?" do
    it "should cross at lower or equal price for bid order" do
      order = Matching.mock_order(type: :bid, price: '10.0'.to_d)
      order.crossed?('9.0'.to_d).should be_true
      order.crossed?('10.0'.to_d).should be_true
      order.crossed?('11.0'.to_d).should be_false
    end

    it "should cross at higher or equal price for ask order" do
      order = Matching.mock_order(type: :ask, price: '10.0'.to_d)
      order.crossed?('9.0'.to_d).should be_false
      order.crossed?('10.0'.to_d).should be_true
      order.crossed?('11.0'.to_d).should be_true
    end
  end
end
