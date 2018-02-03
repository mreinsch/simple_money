# SimpleMoney

Simple implementation of Money

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_money'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_money

## Usage

```
require 'simple_money'

# Configure the currency rates with respect to a base currency (here EUR):

SimpleMoney.conversion_rates('EUR', {
  'USD'     => 1.11,
  'Bitcoin' => 0.0047
})

# Instantiate money objects:

fifty_eur = SimpleMoney::Money.new(50, 'EUR')

# Get amount and currency:

fifty_eur.amount   # => 50
fifty_eur.currency # => "EUR"
fifty_eur.inspect  # => "50.00 EUR"

# Convert to a different currency (should return a SimpleMoney::Money
# instance, not a String):

fifty_eur.convert_to('USD') # => 55.50 USD

# Perform operations in different currencies:

twenty_dollars = SimpleMoney::Money.new(20, 'USD')

# Arithmetics:

fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD

# Comparisons (also in different currencies):

twenty_dollars == SimpleMoney::Money.new(20, 'USD') # => true
twenty_dollars == SimpleMoney::Money.new(30, 'USD') # => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
fifty_eur_in_usd == fifty_eur          # => true

twenty_dollars > SimpleMoney::Money.new(5, 'USD')   # => true
twenty_dollars < fifty_eur             # => true
```

### Limitations

This is a simple implementation of a Money object, and comes with several limitations:

#### Precision

The Money object stores the amount as a Numeric. Using `#amount` you can get the precise value.

When comparing or printing, we'll always round to two decimal places. This is not appropriate for all currencies (for instance JPY has no decimals, while Bitcoin usually requires more decimal places). This could be solved by adding a Currency class holding all those definitions.

Also, you might get inconsistent looking behaviour if you're working with small amounts, like the following:

```
zero_amount = SimpleMoney::Money.new(0, 'EUR')
zero_amount.inspect                    # => 0.00 EUR
small_amount = SimpleMoney::Money.new(0.001, 'EUR')
small_amount.inspect                   # => 0.00 EUR
small_amount == zero_amount            # => true
small_amount * 10                      # => 0.01 EUR
zero_amount * 10                       # => 0.00 EUR
zero_amount * 10 == small_amount * 10  # => false
```

This is by design.

#### Currencies

We're not checking validity of currencies. This could also be solved by adding a Currency class and adding a data file with all currencies (ISO 4217).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mreinsch/simple_money.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
