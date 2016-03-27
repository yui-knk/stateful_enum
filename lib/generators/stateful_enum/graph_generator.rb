require 'rails/generators/named_base'

module StatefulEnum
  module Generators
    class GraphGenerator < ::Rails::Generators::NamedBase
      desc 'Draws a state machine diagram'
      def draw
        require 'graphviz'
        StatefulEnum::Machine.prepend StatefulEnum::Graph
        class_name.constantize
      end
    end
  end

  module Graph
    def initialize(model, _column, states, prefix, suffix, &block)
      super
      GraphDrawer.new model, states, prefix, suffix, &block if block
    end

    class GraphDrawer
      def initialize(model, states, prefix, suffix, &block)
        @states, @prefix, @suffix = states, prefix, suffix
        @g = ::GraphViz.new 'G', rankdir: 'TB'

        states.each do |state|
          @g.add_node state.to_s, label: state.to_s, width: '1', height: '1', shape: 'ellipse'
        end

        @g.output png: "#{model.name}.png"
      end
    end
  end
end
