module StatefulEnum
  class Machine
    def initialize(model, column, states, &block)
      @model, @column, @states, @event_names = model, column, states, []

      # undef non-verb methods e.g. Model#active!
      states.each do |state|
        @model.send :undef_method, "#{state}!"
      end

      instance_eval(&block) if block
    end

    def event(name, &block)
      raise "event: :#{name} has already been defined." if @event_names.include? name
      Event.new @model, @column, @states, name, &block
      @event_names << name
    end

    class Event
      def initialize(model, column, states, name, &block)
        @model, @column, @states, @name, @transitions, @before, @after = model, column, states, name, {}, nil, nil

        instance_eval(&block) if block

        define_transition_methods
      end

      def define_transition_methods
        column, name, transitions, before, after = @column, @name, @transitions, @before, @after

        @model.send(:define_method, name) do
          to, condition = transitions[self.send(column).to_sym]
          #TODO better error
          if to && (!condition || instance_exec(&condition))
            #TODO transaction?
            instance_eval(&before) if before
            ret = self.class.instance_variable_get(:@_enum_methods_module).instance_method("#{to}!").bind(self).call
            instance_eval(&after) if after
            ret
          else
            false
          end
        end

        @model.send(:define_method, "#{name}!") do
          send(name) || raise('Invalid transition')
        end

        @model.send(:define_method, "can_#{name}?") do
          transitions.has_key? self.send(column).to_sym
        end

        @model.send(:define_method, "#{name}_transition") do
          transitions[self.send(column).to_sym].try! :first
        end
      end

      def transition(transitions, options = {})
        if options.blank?
          options[:if] = transitions.delete :if
          #TODO should err if if & unless were specified together?
          if (unless_condition = transitions.delete :unless)
            options[:if] = -> { !instance_exec(&unless_condition) }
          end
        end
        transitions.each_pair do |from, to|
          raise "Undefined state #{to}" unless @states.include? to
          Array(from).each do |f|
            raise "Undefined state #{f}" unless @states.include? f
            @transitions[f] = [to, options[:if]]
          end
        end
      end

      def all
        @states
      end

      def before(&block)
        @before = block
      end

      def after(&block)
        @after = block
      end
    end
  end
end
