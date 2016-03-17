require 'stateful_enum/machine'

module StatefulEnum
  module ActiveRecordEnumExtension
    #   enum status: {unassigned: 0, assigned: 1, resolved: 2, closed: 3} do
    #     event :assign do
    #       transition :unassigned => :assigned
    #     end
    #   end
    def enum(definitions, &block)
      enum = super definitions

      if block
        definitions.each_key do |column|
          states = enum[column]
          StatefulEnum::Machine.new self, column, (states.is_a?(Hash) ? states.keys : states), &block
        end
      end
    end
  end
end
