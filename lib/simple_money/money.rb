# frozen_string_literal: true

module SimpleMoney
  class Money
    include Comparable

    attr_reader :amount, :currency

    def initialize(amount, currency)
      raise InvalidAmountError, "invalid amount #{amount}" unless amount.is_a?(Numeric)
      @amount = amount
      @currency = currency
    end

    def inspect
      format("%.2f %s", amount, currency)
    end

    def convert_to(target_currency)
      return self if currency == target_currency
      Money.new(amount * ::SimpleMoney.conversion_rate(currency, target_currency), target_currency)
    end

    def +(other)
      raise InvalidAmountError, "can only add Money to Money" unless other.is_a?(Money)
      Money.new(amount + other.convert_to(currency).amount, currency)
    end

    def -(other)
      raise InvalidAmountError, "can only add Money to Money" unless other.is_a?(Money)
      Money.new(amount - other.convert_to(currency).amount, currency)
    end

    def /(factor)
      raise InvalidAmountError, "invalid factor #{factor}" unless factor.is_a?(Numeric)
      Money.new(amount / factor.to_f, currency)
    end

    def *(factor)
      raise InvalidAmountError, "invalid factor #{factor}" unless factor.is_a?(Numeric)
      Money.new(amount * factor, currency)
    end

    def <=>(other)
      raise InvalidAmountError, "can only compare Money to Money" unless other.is_a?(Money)
      amount.round(2) <=> other.convert_to(currency).amount.round(2)
    end
  end
end
