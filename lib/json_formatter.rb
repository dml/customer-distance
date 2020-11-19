# frozen_string_literal: true

require 'json'

class JsonFormatter
  def parse(line)
    JSON.parse(line, symbolize_names: true)
  end

  def dump(dataset)
    JSON.dump(dataset)
  end
end
