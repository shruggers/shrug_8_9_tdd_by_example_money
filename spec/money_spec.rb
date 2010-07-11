require 'spec_helper'

class Money
  attr_reader :amount, :currency
  protected :amount  
  
  class << self
    def dollar(amount)
      Money.new(amount, :USD)
    end

    def franc(amount)
      Money.new(amount, :CHF)
    end
  end
  
  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end
  
  def ==(other)
    self.currency == other.currency && amount == other.amount
  end

  def *(multiplier)
    Money.new(@amount * multiplier, currency)
  end
end

class Dollar < Money
end

class Franc < Money
end

describe Money do
  it "has a currency" do
    Money.dollar(5).currency.should eq(:USD)
    Money.franc(5).currency.should eq(:CHF)
  end
  
  it "can be checked for equality" do
    Money.dollar(5).should eq(Money.dollar(5))
    Money.dollar(5).should_not eq(Money.dollar(6))
    Money.dollar(5).should_not eq(Money.franc(5))
    Money.franc(5).should_not eq(Money.dollar(5))
  end
end

describe Franc do
  it "can be checked for equality" do
    Money.franc(5).should eq(Money.franc(5))
    Money.franc(5).should_not eq(Money.franc(6))
  end
  
  it "can be multiplied" do
    five = Money.franc(5)
    (five * 2).should eq(Money.franc(10))
    (five * 3).should eq(Money.franc(15))
  end
end

describe Dollar do
  it "can be checked for equality" do
    Money.dollar(5).should eq(Money.dollar(5))
    Money.dollar(5).should_not eq(Money.dollar(6))
  end
  
  it "can be multiplied" do
    five = Money.dollar(5)
    (five * 2).should eq(Money.dollar(10))
    (five * 3).should eq(Money.dollar(15))
  end
end
