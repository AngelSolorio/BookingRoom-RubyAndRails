module BookingsHelper
  
  def months
    @months = ['january','february','march','april','may','june','july','august','september','october','november','december']
  end
  
  def stylized_date(booking_date)
    "#{booking_date.day} #{(months[(booking_date.month-1)]).capitalize} #{booking_date.year}"
  end
  
  def stylized_timeframe(start_date,end_date)
    "#{start_date.hour}:#{start_date.min} - #{end_date.hour}:#{end_date.min} hrs"
  end
  
end
