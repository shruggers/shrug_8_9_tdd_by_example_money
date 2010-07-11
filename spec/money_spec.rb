require 'spec_helper'

class Dollar
  def *(other)
  end
end

describe Dollar do
  it "can be multiplied" do
    five = Dollar.new(5)
    ten = five * 2
    ten.amount.should eq(10)
  end
end
