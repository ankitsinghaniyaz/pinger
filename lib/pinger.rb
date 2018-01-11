require "pinger/version"
require "pinger/exit_code"
require "pinger/parser"
require "pinger/client"

module Pinger
  parser = Pinger::Parser.new(ARGV)
  options, website = parser.parse!

  duration = options[:duration]
  interval = options[:interval]

  client = Pinger::Client.new(website, duration, interval)
  mean_response_time = client.compute_mean_response

  puts "#{website} mean response time for #{duration/interval} trips: #{mean_response_time.round(2)} ms"
end
