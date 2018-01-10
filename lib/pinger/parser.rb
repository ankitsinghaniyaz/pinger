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
      if self.args.length == 0 || self.args.length > 1
        puts "URL is required to use pinger"
        puts parser
        exit 1
      end

      self.url = self.args[0]
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
        opts.on("-d", "--duration D", "Duration to run the test, deafult: 60 seconds") do |duration|
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
      # exit with non 0 error code
      exit 1
    end
  end
end
