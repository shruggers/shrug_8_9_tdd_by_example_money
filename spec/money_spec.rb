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
  
  def reduce(bank, options)
    Money.new(amount / bank.rate(currency, options[:to]), options[:to])
  end
end

class Bank
  def initialize
    @rates = { }
  end
  
  def add_rate(from, to, rate)
    @rates[ [from, to] ] = rate
  end
  
  def rate(from, to)
    return 1 if from == to
    @rates[ [from, to] ]
  end
  
  def reduce(source, options)
    source.reduce(self, to: options[:to])
  end
end

class Sum
  attr_reader :augend, :addend
  
  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end
  
  def reduce(bank, options)
    Money.new(
      augend.reduce(bank, to: options[:to]).amount +
      addend.reduce(bank, to: options[:to]).amount,
      options[:to]
    )
  end
  
  def +(addend)
    Sum.new(self, addend)
  end
  
  def *(multiplier)
    Sum.new(augend * multiplier, addend * multiplier)
  end
end

describe Bank do
  let(:bank) { Bank.new }
  
  it "reduces sums" do
    sum = Sum.new(Money.dollar(3), Money.dollar(4))
    bank.reduce(sum, to: :USD).should eq(Money.dollar(7))
  end
  
  describe "rates" do
    it "has an identity rate" do
      bank.add_rate(:CHF, :USD, 2)
      bank.rate(:USD, :USD).should eq(1)
    end
  end
  
  describe "reducing Money" do
    it "reduces to the same currency" do
      bank.reduce(Money.dollar(1), to: :USD).should eq(Money.dollar(1))
    end

    it "reduces to other currencies" do
      bank.add_rate(:CHF, :USD, 2)
      bank.reduce(Money.franc(2), to: :USD).should eq(Money.dollar(1))
    end
  end
end

describe Sum do
  let(:bank) { Bank.new }
  
  it "can be added to Money" do
    bank.add_rate(:CHF, :USD, 2)
    sum = Sum.new(Money.dollar(5), Money.franc(10))
    bank.reduce(sum + Money.dollar(5), to: :USD).should eq(Money.dollar(15))
  end
  
  it "can be multiplied" do
    bank.add_rate(:CHF, :USD, 2)
    sum = Sum.new(Money.dollar(5), Money.franc(10))
    bank.reduce(sum * 2, to: :USD).should eq(Money.dollar(20))
  end
end

describe Money do
  let(:bank) { Bank.new }
  
  describe "addition" do
    it "can be added" do
      sum = Money.dollar(5) + Money.dollar(5)
      bank.reduce(sum, to: :USD).should eq(Money.dollar(10))
    end

    it "returns a sum" do
      sum = Money.dollar(5) + Money.dollar(5)
      sum.augend.should eq(Money.dollar(5))
      sum.addend.should eq(Money.dollar(5))
    end
    
    it "can add mixed currencies" do
      bank.add_rate(:CHF, :USD, 2)
      bank.reduce(Money.dollar(5) + Money.franc(10), to: :USD).should eq(Money.dollar(10))
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
