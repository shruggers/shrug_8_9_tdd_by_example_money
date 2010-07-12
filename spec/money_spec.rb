require 'spec_helper'
require_relative '../lib/money'

describe Money do
  it "can be multiplied" do
    (Money.dollar(5)*3).should eq(Money.dollar(15))
    (Money.franc(5)*2).should eq(Money.franc(10))
  end
  
  [
    [5, 3, 15],
    [4, 7, 28]
  ].each do |amount, multiplier, product|
    it "can be multiplied" do
      (Money.dollar(amount)*multiplier).should eq(Money.dollar(product))
    end      
  end
  
  it "supports equality" do
    Money.dollar(5).should eq(Money.dollar(5))
    Money.dollar( 5 ).should_not eq( Money.dollar( 6 ) )
    Money.dollar( 5 ).should_not eq( Money.franc( 5 ) )
  end
  
  it "has a currency" do
    Money.dollar(1).currency.should eq(:USD)
    Money.franc(1).currency.should eq(:CHF)
  end
end
