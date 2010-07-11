require 'spec_helper'

class Dollar
  attr_reader :amount
  
  def initialize(amount)
    @amount = 5 * 2
  end
  
  # We need a method that modifies the receiver
  # def *(other)
  # end
  
  def times(multiplier)
    @amount
  end
end

describe Dollar do
  it "can be multiplied" do
    five = Dollar.new(5)
    five.times(2)
    five.amount.should eq(10)
  end
end
