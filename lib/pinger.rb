# @author Ankit Singhaniya <ankit.singhaniyaz@gmail.com>

require "pinger/version"
require "pinger/exit_code"
require "pinger/parser"
require "pinger/client"

# Pinger is a library to probe any url for a given amount of time
# in specified time interval and compute the mean response time from the server
module Pinger
  parser = Pinger::Parser.new(ARGV)
  options, website = parser.parse!

  duration = options[:duration]
  interval = options[:interval]

  client = Pinger::Client.new(website, duration, interval)
  mean_response_time = client.compute_mean_response

  puts "#{website} mean response time for #{duration/interval} trips: #{mean_response_time.round(2)} ms"
end
