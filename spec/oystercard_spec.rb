require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:min_balance){Oystercard::MIN_BALANCE}
  let(:entry_station){Oystercard::entry_station}

  it 'is expected to initialise with balance 0 ' do
    expect(oystercard.balance).to eq 0
  end

  context 'while card has a working balance' do

    before { oystercard.top_up(10) }
    describe '#top_up' do

      it 'is expected to add the argument passed to the balance variable' do
        expect(oystercard.balance).to eq 10
      end
    end

    describe '#touch_in' do

      it 'is expected to change in_journey? to true' do
        oystercard.touch_in(station)
        expect(oystercard).to be_in_journey
      end
    end

    describe '#touch_out' do
      it 'is expected to change in_journey? to false' do
        oystercard.touch_in(station)
        oystercard.touch_out
        expect(oystercard).not_to be_in_journey
      end

      it 'is expected to reduce balance by fare on touch_out' do
        expect{oystercard.touch_out}.to change{oystercard.balance}.by (-Oystercard::FARE)
      end
    end
  end

  context 'while card does not have a working balance' do
    describe '#top_up' do

      it 'is expected to return the argument passed plus current balance' do
        expect(oystercard.top_up(5)).to eq 5
      end

      it 'is expected to raise error if topup will raise balance over cap' do
        oystercard.top_up(Oystercard::CARD_CAP)
        cap_exceeded = "Cap exceeded £#{Oystercard::CARD_CAP}"
        expect { oystercard.top_up(1) }.to raise_error cap_exceeded
      end
    end

    describe '#in_journey?' do

      it 'is in_journey? false on initialisation' do
        expect(oystercard.in_journey?).to be false
      end
    end

    describe '#touch_in' do

      it 'is expected to raise an error if balance is below £1 at time of touch in' do
        expect{ oystercard.touch_in(station) }.to raise_error "Balance too low, please top up"
      end
      it 'remembers entry station after touch in' do
        oystercard.top_up(min_balance)
        expect(oystercard.touch_in(station)).to eq entry_station
      end

      it { is_expected.to respond_to(:touch_in).with(1).argument }
    end
  end
end
