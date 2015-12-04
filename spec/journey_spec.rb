require 'journey'

describe Journey do

  xit 'is in_journey? false on initialisation' do
    expect(oystercard.in_journey?).to be false
  end

  xit 'initializes with empty list of journeys' do
    expect(oystercard.current_trip).to eq({})
  end

  xit 'is expected to change in_journey? to true' do
    oystercard.touch_in(entry_station)
    expect(oystercard).to be_in_journey
  end
end
