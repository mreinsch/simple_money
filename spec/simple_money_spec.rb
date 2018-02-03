# frozen_string_literal: true

RSpec.describe SimpleMoney do
  before(:all) do
    SimpleMoney.conversion_rates('EUR', 'USD' => 1.11, 'Bitcoin' => 0.0047)
  end

  it "has a version number" do
    expect(SimpleMoney::VERSION).not_to be nil
  end

  describe '.conversion_rate' do
    it 'converts from EUR to USD' do
      expect(SimpleMoney.conversion_rate('EUR', 'USD')).to eq(1.11)
    end
    it 'converts from EUR to Bitcoin' do
      expect(SimpleMoney.conversion_rate('EUR', 'Bitcoin')).to eq(0.0047)
    end
    it 'converts from USD to EUR' do
      expect(SimpleMoney.conversion_rate('USD', 'EUR')).to eq(0.9009009009009008)
    end
    it "doesn't convert from USD to Bitcoin" do
      expect { SimpleMoney.conversion_rate('USD', 'Bitcoin') }.to raise_exception(SimpleMoney::NoConversionRateError)
    end
  end
end
