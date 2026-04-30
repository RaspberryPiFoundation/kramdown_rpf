# frozen_string_literal: true

module Kramdown
  module Parser
    # Adjacent RFM hint blockquotes are authored separately but rendered as the
    # legacy grouped hints panel. Keeping this as a tree pass avoids complicating
    # the blockquote parser with sibling lookahead.
    module RFMHintGrouping
      private

      def group_rfm_hints(element)
        element.children.each { |child| group_rfm_hints(child) }
        grouped_children = []
        index = 0

        while index < element.children.length
          child = element.children[index]
          unless rfm_hint?(child)
            grouped_children << child
            index += 1
            next
          end

          hints, trailing_blanks, index = collect_adjacent_hints(element.children, index)
          grouped_children.concat(group_hints(hints))
          grouped_children.concat(trailing_blanks)
        end

        element.children = grouped_children
      end

      def collect_adjacent_hints(children, index)
        hints = [children[index]]
        index += 1

        loop do
          blanks = []
          while index < children.length && children[index].type == :blank
            blanks << children[index]
            index += 1
          end

          return [hints, blanks, index] unless index < children.length && rfm_hint?(children[index])

          hints << children[index]
          index += 1
        end
      end

      def rfm_hint?(element)
        element.type == :hint && element.options[:rfm]
      end

      def group_hints(hints)
        return hints if hints.length == 1

        hint_blocks = hints.map do |hint|
          "--- hint ---\n#{hint.value[:content]}\n--- /hint ---"
        end

        [::Kramdown::Element.new(:hints, hint_blocks.join("\n"), nil,
                                 location: hints.first.options[:location], rfm: true)]
      end
    end
  end
end
