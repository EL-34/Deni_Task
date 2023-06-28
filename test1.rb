require 'time'

taskStart = "2023-06-05 12:35"
taskEnd = "2023-06-05 12:36"

#puts DateTime.strptime(myDate, "%y/%m/%d %H:%M")
puts parsedTaskStart = Time.strptime(taskStart, "%Y-%m-%d %H:%M")
puts parsedTaskEnd = Time.strptime(taskEnd, "%Y-%m-%d %H:%M")
puts parsedTaskEnd.to_s
puts (parsedTaskEnd - parsedTaskStart) + 60
puts DateTime.now + 10*60

=begin
hash_arr = []
hash1 = {"height" => '5 ft', "weight" => '170 lbs', "hair" => 'White'}
hash2 = {:pet => 'Frog', :nest => 'Bird'}

hash_arr.push(hash1)
hash_arr.push(hash2)

puts hash_arr
=end

hash_arr = [
{"height" => '5 ft', "weight" => '170 lbs', "hair" => 'White'},
{:pet => 'Frog', :nest => 'Bird'}]



def first_option
    puts "space jam"
end

def second_option
    puts "dogs rule"
end

def receives_function(func)
   method(func).call
end

receives_function(:first_option)
