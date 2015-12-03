require_relative 'station'

class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :current_trip, :log
  CARD_CAP = 90
  FARE = 1
  PENALTY_FARE = 6

  def initialize
    @balance = 0
    # @entry_station = nil
    # @exit_station = nil
    @current_trip = {}
    @log = {}
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
    if in_journey?
      penalty
      save_entry(@entry_station)
      touch_out("Penalty Fare!")
      touch_in(station)
    end
    @entry_station = station
    save_entry(station)
  end

  def touch_out(station)
    save_exit(station)
    @log[@log.length + 1] = @current_trip
    @current_trip = {}
    @entry_station = nil
    @exit_station = station
    deduct(FARE)
  end



  private

  def save_entry(station)
    @current_trip[:in] = station
  end

  def save_exit(exit_station)
    @current_trip[:out] = exit_station
  end

  def penalty
    @balance -= (PENALTY_FARE - FARE)
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
