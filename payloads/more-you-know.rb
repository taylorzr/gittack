#!/usr/bin/env ruby

begin
	Process.spawn("imageleap -s 4 -i /Users/apprentice/.gittack/more-you-know.png")
rescue
end

begin
  require 'faker'
  puts
  puts Faker::Hacker.say_something_smart
  puts
rescue
end

