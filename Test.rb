require 'time'
class MyDate
  attr_reader :mon, :day, :year

  def initialize(mon, day, year)
    @mon, @day, @year = mon, day, year
  end
end

d  = Date.parse("2010-10-28")
t  = Time.parse("2010-10-29")
dt = DateTime.parse("2010-10-30")
md = MyDate.new(10,31,2010)

Time.parse("12:00", d)  #=> 2010-10-28 12:00:00 -0500
Time.parse("12:00", t)  #=> 2010-10-29 12:00:00 -0500
Time.parse("12:00", dt) #=> 2010-10-30 12:00:00 -0500
Time.parse("12:00", md) #=> 2010-10-31 12:00:00 -0500

#puts Time.parse("12:00", d)




puts MyDate.new(@mon = 10, @day = 31, @year = 2023)

i = "Sudo Placements"

# using for loop with the range
for a in 1..1 do

 puts i

 start_date = Date.parse "2012-03-02 14:46:21"
 end_date =  Date.parse "2012-04-02 14:46:21"

 puts start_date + 1

end
