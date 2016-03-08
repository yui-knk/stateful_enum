module MechanicMachine
  class Machine
    def initialize(model, column, states, &block)
      @model, @column, @states, @event_names = model, column, states, []

      instance_eval(&block) if block
    end

    def event(name, &block)
      raise "event: :#{name} has already been defined." if @event_names.include? name
      Event.new @model, @column, @states, name, &block
      @event_names << name
    end

    class Event
      def initialize(model, column, states, name, &block)
        @model, @column, @states, @name, @transitions = model, column, states, name, {}

        instance_eval(&block) if block

        define_transition_methods
      end

      def define_transition_methods
        column, name, transitions = @column, @name, @transitions

        @model.send(:define_method, name) do
          if (to = transitions[self.send(column).to_sym])
            self.class.instance_variable_get(:@_enum_methods_module).instance_method("#{to}!").bind(self).call
          else
            false
          end
        end
      end

      def transition(transitions)
        transitions.each_pair do |from, to|
          raise "Undefined state #{from}" unless @states.has_key? from
          raise "Undefined state #{to}" unless @states.has_key? to
          @transitions[from] = to
        end
      end
    end
  end
end
