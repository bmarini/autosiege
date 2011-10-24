require 'mixlib/cli'

module Autosiege
  class CLI
    include Mixlib::CLI

    option :setup,
      :short => "-s",
      :long => "--setup",
      :boolean => true,
      :description => "Copy example configuration files to default locations"

    option :config_file,
      :short => "-c CONFIG",
      :long  => "--config CONFIG",
      :default => 'config/siege/siegerc',
      :description => "The siege configuration file to use (default: ./config/siege/siegerc)"

    option :urls_file,
      :short => "-u URLSFILE",
      :long  => "--urls URLSFILE",
      :default => 'config/siege/urls.txt',
      :description => "The urls file to use (default: ./config/siege/urls.txt)"

    option :log_file,
      :short => "-l LOGFILE",
      :long  => "--log LOGFILE",
      :description => "The log file location (default: ./log/siege.log)",
      :default => 'log/siege.log'

    option :help,
      :short => "-h",
      :long => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0

    def self.run
      cli = new
      begin
        cli.parse_options
      rescue OptionParser::InvalidOption
        puts cli.opt_parser
        exit 1
      end

      cli.run
    end

    def run
      if config[:setup]
        setup
        exit 0
      else
        ENV['SIEGE_LOGFILE'] = config[:logfile]
        system "siege --concurrent=25 --internet --time 1m --reps=1 --rc=#{config[:urls_file]} --log --file=#{config[:config_file]}"
      end
    end

    def setup
      system "mkdir -p config/siege"
      system "mkdir -p log"

      siegefile = File.expand_path("../../conf/siegerc", __FILE__)
      system "cp #{siegefile} conf/siege/siegerc"

      urlsfile = File.expand_path("../../conf/urls.txt", __FILE__)
      system "cp #{urlsfile} conf/siege/urls.txt"
    end
  end
end

