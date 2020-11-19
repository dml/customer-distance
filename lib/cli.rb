# frozen_string_literal: true

require 'json'
require_relative '../lib/distance_filter'
require_relative '../lib/json_formatter'
require_relative '../lib/search'

class CLI
  def self.run
    lines = IO.readlines(File.open(ARGV.fetch(0)))
    search = Search.new
    search.formatter = JsonFormatter.new
    search.filter = DistanceFilter.new(-6.257664, 53.339428, 100.0)
    search.process(lines)
    search.print_sorted($stdout)
  rescue IndexError, Errno::ENOENT
    exit(1)
  end
end
