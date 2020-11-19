# frozen_string_literal: true

class Search
  attr_accessor :formatter, :filter
  attr_reader :data

  def initialize
    @data = {}
  end

  def process(lines)
    @data = lines.each_with_object({}) do |line, memo|
      record = formatter.parse(line)
      user_id = record[:user_id]
      name = record[:name]
      memo[user_id] = name if filter.affirm(record)
    end
  end

  def print_sorted(output)
    data.keys.sort.each do |user_id|
      dataset = {
        name: data[user_id],
        user_id: user_id
      }

      output.puts formatter.dump(dataset)
    end
  end
end
