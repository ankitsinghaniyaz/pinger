require "net/http"
require "benchmark"

module Pinger
  # Client makes the actual network calls to the validated url.
  # It takes care of threading and how multiple calls will be made in a non-blocking fashion
  # It also computes the mean response time for all the calls
  class Client
    # @return [String] the website which will be pinged
    attr_reader :website
    # @return [Integer] total duration in seconds for running the probe
    attr_reader :duration
    # @return [Number] interval in seconds between each request
    attr_reader :interval
    # @return [Number] no of trips/requests the client will make
    attr_reader :trips
    # @return [[Number]] array of response times in seconds
    attr_reader :response_times

    def initialize(website, duration, interval)
      @website = website
      @duration = duration
      @interval = interval
      @trips = duration / interval
      @response_times = []
    end

    # compute_mean_response is the methods which make calculated number of trips
    # to the url in given interval of time. It also computes the time for each call
    # and how the mean response time
    # @return [String] the mean response time in milliseconds
    def compute_mean_response
      (0...trips).map do |trip|
        async_benchmark_request(trip)
      end.map(&:value)

      # calcualte the sum of response times
      # total time taken / # of trips
      (@response_times.inject(:+) / trips)
    end


    private

    def async_benchmark_request(trip)
      Thread.new do
        # sleep for a calculated interval
        # eg: trip1: 0 * 10 = 0
        # eg: trip2: 1 * 10 = 10
        sleep(trip * interval)
        # time the actual requests
        time_taken = benchmark_request
        response_times << time_taken
        puts("#{website} response time for trip #{trip + 1}: #{time_taken.round(2)} ms")
      end
    end

    def benchmark_request
      time = Benchmark.realtime do
        make_request
      end
      # convert the time taken in to milliseconds
      time *= 1000
    end

    def make_request
      Net::HTTP.get(URI(website))
    rescue => e
      puts e
      exit Pinger::ExitCode::NETWORK_ERROR
    end
  end
end
