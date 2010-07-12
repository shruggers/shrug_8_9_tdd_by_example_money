class Money
  attr_reader :amount, :currency
  protected :amount
  
  def initialize( amount, currency )
    @amount = amount
    @currency = currency
  end
  
  class << self
    def dollar(amount)
      Money.new(amount, :USD)
    end
    
    def franc(amount)
      Money.new(amount, :CHF)
    end
  end
  
  def ==( other )
    currency == other.currency && @amount == other.amount
  end
  
  def *( multiplier )
    Money.new(@amount * multiplier, currency)
  end
  
end
