class Oystercard

  attr_reader :balance
  CARD_CAP = 90
  MIN_BALANCE = 1
  FARE = 1

  def initialize
    @balance = 0
    @traveling = false
    @entry_station = nil
  end

  def top_up(amount)
    fail "Cap exceeded £#{CARD_CAP}" if exceed_cap?(amount)
    @balance += amount
  end

  def in_journey?
    traveling
  end

  def touch_in(station)
    fail "Balance too low, please top up" if balance_too_low?
    @traveling = true
    @entry_station = station
  end

  def touch_out
    @traveling = false
    deduct(FARE)
  end



  private

  attr_reader :traveling

  def exceed_cap?(amount)
    balance + amount > CARD_CAP
  end

  def balance_too_low?
    balance < MIN_BALANCE
  end

  def deduct(amount)
    @balance -= FARE
  end


end
