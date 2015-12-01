

describe 'feature_test' do
  let(:oystercard){Oystercard.new}
  let(:card_cap){Oystercard::CARD_CAP}
  let(:min_balance){Oystercard::MIN_BALANCE}
  let(:balance){Oystercard::balance}


  # In order to use public transport
  # As a customer
  # I want money on my card
    it 'new card balance of 0' do
      expect(oystercard.balance).to eq 0
    end

    #In order to keep using public transport
    # As a customer
    # I want to add money to my card
    it 'add balance to card' do
    oystercard.top_up(5)
    expect(oystercard.balance).to eq 5
    end

  # In order to protect my money
  # As a customer
  # I don't want to put too much money on my card
  it 'raise error when top_up exceeds cap' do
    oystercard.top_up(card_cap)
    expect{oystercard.top_up(min_balance)}.to raise_error "Cap exceeded £#{Oystercard::CARD_CAP}"
  end

  # In order to get through the barriers
  # As a customer
  # I need to touch in
  it 'traveling becomes true after touch_in' do
    oystercard.top_up(min_balance)
    oystercard.touch_in
    expect(oystercard).to be_in_journey
  end
  # and out
  it 'traveling becomes false after touch_out' do
    oystercard.top_up(min_balance)
    oystercard.touch_in
    oystercard.touch_out
    expect(oystercard).not_to be_in_journey
  end

  # In order to pay for my journey
  # As a customer
  # I need to have the minimum amount for a single journey
  it 'touch_in to raise error if below card below min_balance' do
    expect{oystercard.touch_in}.to raise_error "Balance too low, please top up"
  end

  #In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card
  it 'reduce balance by fare amount on touch_out' do
    expect{oystercard.touch_out}.to change{oystercard.balance}.by (-Oystercard::FARE)
  end

ffffff
end
