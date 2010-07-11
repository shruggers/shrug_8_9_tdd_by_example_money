require 'spec_helper'

class Dollar
  attr_reader :amount
  protected :amount
  
  def initialize(amount)
    @amount = amount
  end
  
  def *(multiplier)
    Dollar.new(@amount * multiplier)
  end
  
  def ==(other)
    amount == other.amount
  end
end

describe Dollar do
  it "can be checked for equality" do
    Dollar.new(5).should eq(Dollar.new(5))
    Dollar.new(5).should_not eq(Dollar.new(6))
  end
  
  it "can be multiplied" do
    five = Dollar.new(5)
    (five * 2).should eq(Dollar.new(10))
    (five * 3).should eq(Dollar.new(15))
  end
end
