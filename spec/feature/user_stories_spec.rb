require 'station'
describe 'User Stories' do
  let(:oystercard){Oystercard.new}
  let(:exit_station){ double(:exit_station) }
  let(:card_cap){Oystercard::CARD_CAP}
  let(:fare){Oystercard::FARE}
  let(:balance){Oystercard::balance}
  let(:station){Station.new("bank",1)}
  let(:penalty){Oystercard::PENALTY_FARE}



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
    expect{oystercard.touch_in(station)}.to raise_error "Balance too low, please top up"
  end

  context 'topped up fresh oysters' do

    before do
      oystercard.top_up(card_cap)
    end

    #In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
    it 'reduce balance by fare amount on touch_out' do
      oystercard.touch_in(station)
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by -fare
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
        oystercard.touch_in(station)
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
        expect(oystercard.current_trip[:in]).to eq station
      end

      it 'entry station is cleared at touch out' do
        oystercard.touch_out("Kings cross")
        expect(oystercard.entry_station).to eq nil
      end

      # In order to know where I have been
      # As a customer
      # I want to see to all my previous trips
      it 'logs exit station' do
        oystercard.touch_out(exit_station)
        expect(oystercard.log[oystercard.log.length]).to include(out: exit_station)
      end

      it 'entry station is stored in log current_trip' do
        expect(oystercard.current_trip[:in]).to eq station
      end

      it 'exit station is stored in out: of log' do
        oystercard.touch_out("kings cross")
        expect(oystercard.log).to eq ({1=>{:in => station, :out => "kings cross"}})
      end

      # In order to know how far I have travelled
      # As a customer
      # I want to know what zone a station is in
      it 'new stations have a zone' do
        expect(station.zone).to eq 1
      end

      # In order to be charged correctly
      # As a customer
      # I need a penalty charge deducted if I fail to touch out
      it 'charge penalty when card not touched out' do
        oystercard.touch_in("Bank")
        expect{oystercard.touch_in("Victoria")}.to change{oystercard.balance}.by -penalty
      end

      #When not touched out, update log
      it 'when not touched out update log of penalty on next touch in' do
        oystercard.touch_in("Bank")
        expect(oystercard.log).to eq ({1=>{:in => station, :out => "Penalty Fare!"}})
      end

      # In order to be charged correctly
      # As a customer
      # I need a penalty charge deducted if I fail to touch in
      it 'charge penalty when card not touched in' do
        oystercard.touch_out("Bank")
        expect{oystercard.touch_out("Victoria")}.to change{oystercard.balance}.by -penalty - fare
      end
    end

    #When not touched in, update log
    it 'when not touched in update log of penalty on touch out' do
      oystercard.touch_out("Bank")
      expect(oystercard.log).to eq ({1=>{:in => "Penalty Fare!", :out =>"Bank"}})
    end
  end
end
