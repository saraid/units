describe Units::Quantity do
  subject { Units::Quantity.new(1, Units::Meter.instance) }

  it do
    expect(subject.number).to eq(1)
    expect(subject.unit).to eq(Units::Meter.instance)
  end

  it 'should be able to add same-type different-specific quantities' do
    meter = Units::Quantity.new(1, Units::Meter.instance)
    kilometer = Units::Quantity.new(1, Units::Kilometer.instance)

    expect { meter + kilometer }.not_to raise_error
    expect(meter + kilometer).to eq(Units::Quantity.new(1001, Units::Meter.instance))
  end

  context 'verify operator(Numeric, Quantity) works' do
    it do
      expect { 1 + subject }.not_to raise_error
      expect(1 + subject).to eq(Units::Quantity.new(2, Units::Meter.instance))
    end

    it do
      expect { 1 * subject }.not_to raise_error
      expect(1 * subject).to eq(Units::Quantity.new(1, Units::Meter.instance))
    end

    it do
      expect { 1 / subject }.not_to raise_error
      q = 1 / subject
      expect(q.number).to eq(1)
      expect(q.unit.to_s).to eq('1·m^-1')
    end

    it do
      expect { 1 ** subject }.to raise_error(ArgumentError)
    end
  end

  context 'verify operator(Quantity, Numeric) works' do
    it do
      expect { subject + 1 }.not_to raise_error
      expect(subject + 1).to eq(Units::Quantity.new(2, Units::Meter.instance))
    end

    it do
      expect { subject * 1 }.not_to raise_error
      expect(subject * 1).to eq(Units::Quantity.new(1, Units::Meter.instance))
    end

    it do
      expect { subject / 1 }.not_to raise_error
      expect(subject * 1).to eq(Units::Quantity.new(1, Units::Meter.instance))
    end

    it do
      expect { subject ** 1 }.not_to raise_error
      q = subject ** 1
      expect(q.number).to eq(1)
      expect(q.unit.to_s).to eq('m')
      expect(subject ** 1).to eq(Units::Quantity.new(1, Units::Meter.instance))
    end
  end
end
