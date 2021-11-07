require 'logue/loggable'

module Dupless
  module Obj
    def to_string obj, *fields
      fields.collect do |field|
        "#{field}: #{obj.send(field).to_s}"
      end.join ", "      
    end

    def assert_not_null name, value
      raise "#{name} cannot be null" unless value
    end
  end
end
