require "optionparser"

module Pinger
  class Parser
    attr_accessor :args, :options, :url, :parser

    def initialize(args)
      self.args = args
    end

    def parse!
      parse_options
      parse_url

      [self.options, self.url]
    end

    def parse_url
      # check if the url was provided or not and if more than one url was provied
      if self.args.length == 0 || self.args.length > 1
        puts "URL is required to use pinger"
        puts parser
        exit Pinger::ExitCode::URL_ERROR
      end

      # ok so we have one url, let's set it
      self.url = self.args[0]

      # now let's add an http to the url if the protocol is not mentioned
      # adding http to be safe, as the webiste will redirect to https anyways
      unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
        self.url = "http://#{self.url}"
      end

      self.url
    end

    def parse_options
      options = {
        interval: 10,
        duration: 60
      }

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: pinger [options] url"
        opts.on("-i", "--interval N", Integer, "Probe interval in seconds, default: 10 seconds") do |interval|
          options[:interval] = interval
        end
        opts.on("-d", "--duration D", Integer, "Duration to run the test, deafult: 60 seconds") do |duration|
          options[:duration] = duration
        end
      end

      self.parser = parser
      parser.parse!
      self.options = options
    rescue OptionParser::ParseError => error
      # show the error message
      puts error
      # show the usage instructions
      puts parser
      exit Pinger::ExitCode::OPTIONS_ERROR
    end
  end
end
