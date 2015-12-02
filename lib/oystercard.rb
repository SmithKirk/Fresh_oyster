class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :current_trip
  CARD_CAP = 90
  FARE = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @exit_station = nil
    @current_trip = {}
  end

  def top_up(amount)
    fail "Cap exceeded £#{CARD_CAP}" if exceed_cap?(amount)
    @balance += amount
  end

  def in_journey?
    traveling
  end

  def touch_in(entry_station)
    fail "Balance too low, please top up" if balance_too_low?
    @entry_station = entry_station
    save_entry
  end

  def touch_out(exit_station)
    save_exit(exit_station)
    @entry_station = nil
    @exit_station = exit_station
    deduct(FARE)
  end



  private

  def save_entry
    @current_trip[:in] = entry_station
  end

  def save_exit(exit_station)
    @current_trip[:out] = exit_station
  end

  def traveling
    !!entry_station
  end

  def exceed_cap?(amount)
    balance + amount > CARD_CAP
  end

  def balance_too_low?
    balance < FARE
  end

  def deduct(amount)
    @balance -= FARE
  end


end
