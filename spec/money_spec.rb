require 'spec_helper'

class Money
  attr_reader :amount, :currency
  # protected :amount
  
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
    Money.new(amount * multiplier, currency)
  end
  
  def +(addend)
    Sum.new(self, addend)
  end
  
  def reduce(to)
    self
  end
end

class Bank
  def reduce(source, to)
    source.reduce(to)
  end
end

class Sum
  attr_reader :augend, :addend
  
  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end
  
  def reduce(to)
    Money.new(augend.amount + addend.amount, to)
  end
end

describe Bank do
  let(:bank) { Bank.new }
  it "reduces sums" do
    sum = Sum.new(Money.dollar(3), Money.dollar(4))
    bank.reduce(sum, :USD).should eq(Money.dollar(7))
  end
  
  it "reduces Money" do
    bank.reduce(Money.dollar(1), :USD).should eq(Money.dollar(1))
  end
end

describe Money do
  describe "addition" do
    it "can be added" do
      sum = Money.dollar(5) + Money.dollar(5)
      bank = Bank.new
      bank.reduce(sum, :USD).should eq(Money.dollar(10))
    end

    it "returns a sum" do
      sum = Money.dollar(5) + Money.dollar(5)
      sum.augend.should eq(Money.dollar(5))
      sum.addend.should eq(Money.dollar(5))
    end
  end
  
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
  
  it "can be multiplied" do
    (Money.franc(5) * 2).should eq(Money.franc(10))
    (Money.dollar(5) * 3).should eq(Money.dollar(15))
  end
end
