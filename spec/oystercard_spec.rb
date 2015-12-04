require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:fare){Oystercard::FARE}
  let(:card_cap){Oystercard::CARD_CAP}
  let(:entry_station){ double(:entry_station) }
  let(:exit_station) { double(:exit_station) }
  let(:penalty){Oystercard::PENALTY_FARE}


  it 'is expected to initialise with balance 0 ' do
    expect(oystercard.balance).to eq 0
  end

  it 'is in_journey? false on initialisation' do
    expect(oystercard.in_journey?).to be false
  end

  it 'initializes with empty list of journeys' do
    expect(oystercard.current_trip).to eq({})
  end

  context 'Topped up oysters' do

    before do
      oystercard.top_up(card_cap)
    end

    it 'is expected to be topped up by the amount passed in' do
      expect(oystercard.balance).to eq card_cap
    end

    it 'raise error if card_cap is exceeded' do
      cap_exceeded = "Cap exceeded £#{card_cap}"
      expect { oystercard.top_up(1) }.to raise_error cap_exceeded
    end

    describe '#touch_in' do

      it 'is expected to change in_journey? to true' do
        oystercard.touch_in(entry_station)
        expect(oystercard).to be_in_journey
      end

      it 'remembers entry station after touch in' do
        expect(oystercard.touch_in(entry_station)).to eq oystercard.entry_station
      end

      it 'raise an error if balance is below fare at touch in' do
        oystercard.top_up(-card_cap)
        expect{ oystercard.touch_in(entry_station) }.to raise_error "Balance too low, please top up"
      end

      it 'entry station is stored in current_trip at touch_in' do
        oystercard.touch_in(entry_station)
        expect(oystercard.current_trip[:in]).to eq entry_station
      end

      it 'charge penalty when card not touched out' do
        oystercard.touch_in("Bank")
        expect{oystercard.touch_in("Victoria")}.to change{oystercard.balance}.by -penalty
      end

      it 'when not touched out update log of penalty on next touch in' do
        oystercard.touch_in("Bank")
          oystercard.touch_in("Kings X")
        expect(oystercard.log).to eq ({1=>{:in => "Bank", :out => "Penalty Fare!"}})
      end

    end

    describe '#touch_out' do

      it 'change in_journey? to false at touch out' do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard).not_to be_in_journey
      end

      it 'should change entry_station to nil at touch_out' do
        oystercard.touch_in(entry_station)
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.entry_station }.to eq nil
      end

      it 'is expected to reduce balance by fare on touch_out' do
        oystercard.touch_in("Bank")
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by -fare
      end

      it 'logs exit_station' do
        oystercard.touch_in(entry_station)
        expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.exit_station }.to eq exit_station
      end

      it 'exit station is stored in current_trip at touch_out' do
        oystercard.touch_in("Bank")
        oystercard.touch_out("kings cross")
        expect(oystercard.log).to eq ({1=>{:in => "Bank", :out => "kings cross"}})
      end

      it 'charge penalty when card not touched in' do
        oystercard.touch_out("Bank")
        expect{oystercard.touch_out("Victoria")}.to change{oystercard.balance}.by -penalty - fare
      end

      it 'when not touched in update log of penalty on touch out' do
        oystercard.touch_out("Bank")
        expect(oystercard.log).to eq ({1=>{:in => "Penalty Fare!", :out =>"Bank"}})
      end
    end
  end
end
