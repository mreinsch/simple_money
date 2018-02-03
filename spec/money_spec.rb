# frozen_string_literal: true

RSpec.describe SimpleMoney::Money do
  before(:all) do
    SimpleMoney.conversion_rates('EUR', 'USD' => 1.11, 'Bitcoin' => 0.0047)
  end

  describe '.new / #inspect' do
    {
      [0, 'EUR'] => '0.00 EUR',
      [0.0001, 'EUR'] => '0.00 EUR',
      [-0.0001, 'EUR'] => '-0.00 EUR',
      [50, 'EUR'] => '50.00 EUR',
      [-50, 'EUR'] => '-50.00 EUR',
      [-50.227, 'EUR'] => '-50.23 EUR',
      [50.227, 'EUR'] => '50.23 EUR',
      [41.361314, 'EUR'] => '41.36 EUR',
      [20, 'USD'] => '20.00 USD',
      [900_000_000_000_000, 'USD'] => '900000000000000.00 USD',
      [40.4522, 'Bitcoin'] => '40.45 Bitcoin'
    }.each do |input, output|
      it "creates money object for #{output}" do
        expect(SimpleMoney::Money.new(*input).inspect).to eq(output)
      end
    end

    it "doesn't allow non-numeric amounts" do
      expect { SimpleMoney::Money.new('a', 'EUR') }.to raise_exception(SimpleMoney::InvalidAmountError)
    end
  end

  describe '#convert_to' do
    [
      [[0, 'EUR'], 'USD', '0.00 USD'],
      [[20, 'EUR'], 'EUR', '20.00 EUR'],
      [[50, 'EUR'], 'USD', '55.50 USD'],
      [[-50, 'EUR'], 'USD', '-55.50 USD'],
      [[20, 'USD'], 'EUR', '18.02 EUR'],
      [[20, 'Bitcoin'], 'EUR', '4255.32 EUR']
    ].each do |input, target_currency, output|
      it "converts #{input} to #{output}" do
        expect(SimpleMoney::Money.new(*input).convert_to(target_currency).inspect).to eq(output)
      end
    end

    it "raises exception when converting to currency without rate" do
      amount = SimpleMoney::Money.new(1, 'EUR')
      expect { amount.convert_to('JPY') }.to raise_exception(SimpleMoney::NoConversionRateError)
    end
  end

  describe '#+ / #-' do
    [
      [[0, 'EUR'], [0, 'USD'], '0.00 EUR', '0.00 EUR'],
      [[0, 'USD'], [0, 'EUR'], '0.00 USD', '0.00 USD'],
      [[0, 'USD'], [0, 'USD'], '0.00 USD', '0.00 USD'],
      [[0, 'EUR'], [0, 'EUR'], '0.00 EUR', '0.00 EUR'],
      [[50, 'EUR'], [20, 'EUR'], '70.00 EUR', '30.00 EUR'],
      [[50, 'EUR'], [20, 'USD'], '68.02 EUR', '31.98 EUR'],
      [[50, 'USD'], [20, 'USD'], '70.00 USD', '30.00 USD'],
      [[50, 'USD'], [20, 'EUR'], '72.20 USD', '27.80 USD'],
      [[50, 'USD'], [-20, 'EUR'], '27.80 USD', '72.20 USD']
    ].each do |input1, input2, output_plus, output_minus|
      context "#{input1}, #{input2}" do
        let(:amount1) { SimpleMoney::Money.new(*input1) }
        let(:amount2) { SimpleMoney::Money.new(*input2) }

        it "+ => #{output_plus}" do
          expect((amount1 + amount2).inspect).to eq(output_plus)
        end
        it "- => #{output_minus}" do
          expect((amount1 - amount2).inspect).to eq(output_minus)
        end
      end
    end

    it "raises exception when adding/subtracing non-money objects" do
      amount = SimpleMoney::Money.new(1, 'EUR')
      expect { amount + 1 }.to raise_exception(SimpleMoney::InvalidAmountError)
      expect { amount - 1 }.to raise_exception(SimpleMoney::InvalidAmountError)
    end
  end

  describe '#* / #/' do
    [
      [[0, 'EUR'], 3, '0.00 EUR', '0.00 EUR'],
      [[50, 'EUR'], 3, '150.00 EUR', '16.67 EUR'],
      [[-50, 'EUR'], 3, '-150.00 EUR', '-16.67 EUR'],
      [[20, 'EUR'], 3.14159, '62.83 EUR', '6.37 EUR'],
      [[20, 'USD'], 6, '120.00 USD', '3.33 USD']
    ].each do |input, factor, output_multiplication, output_division|
      context input.to_s do
        let(:amount) { SimpleMoney::Money.new(*input) }

        it "* #{factor} = #{output_multiplication}" do
          expect((amount * factor).inspect).to eq(output_multiplication)
        end

        it "/ #{factor} = #{output_division}" do
          expect((amount / factor).inspect).to eq(output_division)
        end
      end
    end

    it "raises exception when multiplying / dividing by non-numeric" do
      amount = SimpleMoney::Money.new(1, 'EUR')
      expect { amount * 'a' }.to raise_exception(SimpleMoney::InvalidAmountError)
      expect { amount / 'a' }.to raise_exception(SimpleMoney::InvalidAmountError)
    end
  end

  describe '#<=>' do
    [
      [[0, 'EUR'], [0, 'USD'], 0],
      [[50, 'EUR'], [50, 'EUR'], 0],
      [[50, 'EUR'], [50.004, 'EUR'], 0],
      [[50, 'EUR'], [49.995, 'EUR'], 0],
      [[50, 'EUR'], [50.005, 'EUR'], -1],
      [[50, 'EUR'], [49.994, 'EUR'], 1],
      [[50, 'EUR'], [55.50, 'USD'], 0],
      [[50, 'EUR'], [50.01, 'EUR'], -1],
      [[50, 'EUR'], [49.99, 'EUR'], 1]
    ].each do |input1, input2, output|
      it "#{input1} <=> #{input2} = #{output}" do
        a1 = SimpleMoney::Money.new(*input1)
        a2 = SimpleMoney::Money.new(*input2)
        expect(a1 <=> a2).to eq(output)
      end
    end

    it "raises exception when comparing with non-money objects" do
      amount = SimpleMoney::Money.new(1, 'EUR')
      expect { amount <=> 1 }.to raise_exception(SimpleMoney::InvalidAmountError)
    end

    it "compares < (sanity check)" do
      # we're using Comparable module which relies on <=>, so this is just a sanity check
      expect(SimpleMoney::Money.new(10, 'EUR')).to be < SimpleMoney::Money.new(20, 'EUR')
    end
  end
end
