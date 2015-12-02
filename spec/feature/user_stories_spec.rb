describe 'User Stories' do
  let(:oystercard){Oystercard.new}
  let(:entry_station){ double(:entry_station) }
  let(:exit_station){ double(:exit_station) }
  let(:card_cap){Oystercard::CARD_CAP}
  let(:fare){Oystercard::FARE}
  let(:balance){Oystercard::balance}



  # In order to use public transport
  # As a customer
  # I want money on my card
  it 'new card balance of 0' do
    expect(oystercard.balance).to eq 0
  end

  # In order to pay for my journey
  # As a customer
  # I need to have the minimum amount for a single journey
  it 'touch_in to raise error if balance of card is below fare' do
    expect{oystercard.touch_in(entry_station)}.to raise_error "Balance too low, please top up"
  end

  #In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card
  it 'reduce balance by fare amount on touch_out' do
    expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by -fare
  end

  context 'topped up fresh oysters' do

    before do
      oystercard.top_up(card_cap)
    end

    #In order to keep using public transport
    # As a customer
    # I want to add money to my card
    it 'add balance to card' do
      expect(oystercard.balance).to eq card_cap
    end

    # In order to protect my money
    # As a customer
    # I don't want to put too much money on my card
    it 'raise error when top_up exceeds cap' do
      expect{oystercard.top_up(1)}.to raise_error "Cap exceeded £#{card_cap}"
    end

    context 'touched in oysters' do

      before do
        oystercard.touch_in(entry_station)
      end

      # In order to get through the barriers
      # As a customer
      # I need to touch in
      it 'traveling becomes true after touch_in' do
        expect(oystercard).to be_in_journey
      end

      # and out
      it 'traveling becomes false after touch_out' do
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.in_journey? }.to eq false
      end

      # In order to pay for my journey
      # As a customer
      # I need to know where I've travelled from
      it 'remembers entry station after touch in' do
        expect(oystercard.entry_station).to eq entry_station
      end

      it 'entry station is cleared at touch out' do
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.entry_station }.to eq nil
      end

      # In order to know where I have been
      # As a customer
      # I want to see to all my previous trips
      it 'logs exit station' do
        oystercard.touch_out(exit_station)
        expect(oystercard.exit_station).to eq exit_station
      end

      it 'entry station is stored in log current_trip' do
        expect(oystercard.current_trip[:in]).to eq entry_station
      end

      it 'exit station is stored in current_trip at touch_out' do
        oystercard.touch_out(exit_station)
        expect(oystercard.current_trip[:out]).to eq exit_station
      end
    end
  end
end
