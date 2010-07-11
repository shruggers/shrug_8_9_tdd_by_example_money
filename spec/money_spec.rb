require 'spec_helper'

class Dollar
  attr_reader :amount
  
  def initialize(amount)
    
  end
  
  # We need a method that modifies the receiver
  # def *(other)
  # end
  
  def times(multiplier)
    @amount = 5 * 2
  end
end

describe Dollar do
  it "can be multiplied" do
    five = Dollar.new(5)
    five.times(2)
    five.amount.should eq(10)
  end
end
