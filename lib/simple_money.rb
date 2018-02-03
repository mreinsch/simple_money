# frozen_string_literal: true

require "simple_money/version"
require "simple_money/money"

module SimpleMoney
  class InvalidAmountError < ArgumentError
  end

  class NoConversionRateError < ArgumentError
  end

  @conversion_rates = Hash.new { |h, k| h[k] = {} }

  def self.conversion_rates(currency, rates_hash)
    rates_hash.each do |other_currency, rate|
      @conversion_rates[currency][other_currency] = rate
      @conversion_rates[other_currency][currency] = 1.0 / rate
    end
  end

  def self.conversion_rate(currency, target_currency)
    @conversion_rates[currency][target_currency] ||
      raise(NoConversionRateError, "missing conversion rate #{currency}->#{target_currency}")
  end
end
