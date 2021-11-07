require 'logue/loggable'

module Dupless
  module Obj
    def to_string obj, *fields
      fields.collect do |field|
        value = obj.send field
        "#{field}: #{value}"
      end.join ", "      
    end

    def compare x, y, *fields
      fields.each do |field|
        cmp = x.send(field) <=> y.send(field)
        return cmp if cmp.nonzero?
      end
      0
    end

    def assert_not_null name, value
      raise "#{name} cannot be null" unless value
    end
  end
end
