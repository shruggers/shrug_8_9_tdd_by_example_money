require 'spec_helper'

class Dollar
  attr_reader :amount
  
  def initialize(amount)
    @amount = amount
  end
  
  # We need a method that modifies the receiver
  # def *(other)
  # end
  
  def times(multiplier)
    Dollar.new(@amount * multiplier)
  end
end

describe Dollar do
  it "can be multiplied" do
    five = Dollar.new(5)
    product = five.times(2)
    product.amount.should eq(10)
    product = five.times(3)
    product.amount.should eq(15)
  end
end
