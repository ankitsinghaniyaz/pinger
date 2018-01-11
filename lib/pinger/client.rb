require "net/http"
require "benchmark"

module Pinger
  class Client
    attr_accessor :website, :duration, :interval, :trips

    def initialize(website, duration, interval)
      self.website = website
      self.duration = duration
      self.interval = interval
    end

    def compute_mean_response
      trips = duration / interval
      response_times = []

      # make a trip, async
      (0...trips).map do |trip|
        Thread.new do
          # sleep for a calculated interval
          # eg: trip1: 0 * 10 = 0
          # eg: trip2: 1 * 10 = 10
          sleep(trip * interval)

          # time the actual requests
          time_taken = Benchmark.realtime do
            make_request
          end

          # convert the time taken in to milliseconds
          time_taken *= 1000
          response_times << time_taken
          puts("#{website} response time for trip #{trip + 1}: #{time_taken.round(2)} ms")
        end
      end.map(&:value)

      # calcualte the sum of response times
      # total time taken / # of trips
      (response_times.inject(:+) / trips)
    end

    def make_request
      Net::HTTP.get(URI(website))
    rescue => e
      puts e
      exit Pinger::ExitCode::NETWORK_ERROR
    end
  end
end
