# frozen_string_literal: true

require 'json'
require_relative '../lib/distance_calculator'

class CLI
  def self.calculator
    DistanceCalculator.from(-6.257664, 53.339428)
  end

  def self.filter(file_descriptor)
    IO.readlines(file_descriptor).each_with_object({}) do |line, memo|
      record = JSON.parse(line, symbolize_names: true)
      distance = calculator.to(record[:longitude], record[:latitude]).distance
      memo[record[:user_id]] = record[:name] if distance <= 100.0
    end
  end

  def self.run
    data = filter(File.open(ARGV.fetch(0), 'r'))
    data.keys.sort.each do |user_id|
      puts JSON.dump({ name: data[user_id], user_id: user_id })
    end
  rescue Errno::ENOENT
    puts 'Filename does not exist'
    exit(1)
  rescue IndexError
    puts 'Filename is not specified'
    exit(1)
  end
end
