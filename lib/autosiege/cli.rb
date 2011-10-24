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
      :description => "The siege configuration file to use, default is 'config/siege/siegerc'"

    option :urls_file,
      :short => "-u URLSFILE",
      :long  => "--urls URLSFILE",
      :default => 'config/siege/urls.txt',
      :description => "The urls file to use, default is 'config/siege/urls.txt'"

    option :log_file,
      :short => "-l LOGFILE",
      :long  => "--log LOGFILE",
      :description => "The log file location, default is 'log/siege.log'",
      :default => 'log/siege.log'

    option :help,
      :short => "-h",
      :long => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0

    option :concurrency,
      :short => "-c CONCURRENCY",
      :long => "--concurrency CONCURRENCY",
      :default => 25,
      :description => "Number of concurrent users, default is 25"

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
        cmd = "siege --concurrent=#{config[:concurrency]} --internet --time 1m --rc=#{config[:urls_file]} --log --file=#{config[:config_file]}"
        puts cmd
        system cmd
      end
    end

    def setup
      system "mkdir -p log"
      system "touch log/siege.log"

      system "mkdir -p config/siege"
      siegefile = File.expand_path("../../../conf/siegerc", __FILE__)
      system "cp #{siegefile} config/siege/siegerc"

      urlsfile = File.expand_path("../../../conf/urls.txt", __FILE__)
      system "cp #{urlsfile} config/siege/urls.txt"
    end
  end
end

