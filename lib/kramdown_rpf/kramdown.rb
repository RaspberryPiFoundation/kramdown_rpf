require 'kramdown'
require_relative 'rpf'

module Kramdown
  # # Register block-level elements
  # # @private
  class Element
    # Register :challenge as a block-level element
    CATEGORY[:challenge] = :block
    # Register :collapse as a block-level element
    CATEGORY[:collapse] = :block
  end
  #
  module Converter
    class Html
      # Convert :challenge -> HTML
      # @api private
      def convert_challenge(el, _indent)
        RPF::Plugin::Kramdown.convert_challenge_to_html(el.value)
      end

      # Convert :collapse -> HTML
      # @api private
      def convert_collapse(el, _indent)
        RPF::Plugin::Kramdown.convert_collapse_to_html(el.value)
      end
    end

    class Kramdown
      # Convert :challenge -> Markdown (not implemented)
      def convert_challenge(_el, _opts)
        raise NotImplementedError
      end

      # Convert :collapse -> Markdown (not implemented)
      def convert_collapse(_el, _opts)
        raise NotImplementedError
      end
    end

    class Latex
      # Convert :challenge -> LaTEX (not implemented)
      def convert_challenge(_el, _opts)
        raise NotImplementedError
      end

      # Convert :collapse -> LaTEX (not implemented)
      def convert_collapse(_el, _opts)
        raise NotImplementedError
      end
    end
  end

  module Parser
    class KramdownRPF < ::Kramdown::Parser::GFM
      CHALLENGE_PATTERN = /^#{OPT_SPACE}---[ \t]*challenge[ \t]*---(.*?)---[ \t]*\/challenge[ \t]*---/m
      COLLAPSE_PATTERN = /^#{OPT_SPACE}---[ \t]*collapse[ \t]*---(.*?)---[ \t]*\/collapse[ \t]*---/m

      def initialize(source, options)
        super
        @block_parsers.unshift(:challenge)
        @block_parsers.unshift(:collapse)
      end

      # Convert Markdown -> :challenge
      # @api private
      def parse_challenge
        @src.pos += @src.matched_size
        @tree.children << Element.new(:challenge, @src[1])
      end

      define_parser(:challenge, CHALLENGE_PATTERN)

      # Convert Markdown -> :collapse
      # @api private
      def parse_collapse
        @src.pos += @src.matched_size
        @tree.children << Element.new(:collapse, @src[1])
      end

      define_parser(:collapse, COLLAPSE_PATTERN)
    end
  end
end
