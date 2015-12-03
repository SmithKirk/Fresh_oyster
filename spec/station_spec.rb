require 'station'

describe Station do
  subject(:station){described_class.new}
  let(:station){double :station, name: "Bank", zone: 1}

  it 'new stations have a zone' do
    station = Station.new("Bank",1)
    expect(station.zone).to eq 1
  end

  it 'new stations have a name' do
    station = Station.new("Bank",1)
    expect(station.name).to eq "Bank"
  end

end
