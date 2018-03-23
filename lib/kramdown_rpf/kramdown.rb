require 'kramdown'
require_relative 'rpf'

module Kramdown
  # # Register block-level elements
  # # @private
  class Element
    # Register :challenge, :collapse, :hint, and :hint as block-level elements
    CATEGORY[:challenge] = :block
    CATEGORY[:collapse]  = :block
    CATEGORY[:hint]      = :block
    CATEGORY[:save]      = :block
    CATEGORY[:task]      = :block
  end

  module Converter
    class Html
      # Convert :challenge -> HTML
      # @api private
      def convert_challenge(el, _indent)
        RPF::Plugin::Kramdown.convert_challenge_to_html(el.value)
      end

      # Convert :code -> HTML
      # @api private
      def convert_code(el, _indent)
        RPF::Plugin::Kramdown.convert_code_to_html(el.value)
      end

      # Convert :collapse -> HTML
      # @api private
      def convert_collapse(el, _indent)
        RPF::Plugin::Kramdown.convert_collapse_to_html(el.value)
      end

      # Convert :hint -> HTML
      # @api private
      def convert_hint(el, _indent)
        RPF::Plugin::Kramdown.convert_hint_to_html(el.value)
      end

      # Convert :hints -> HTML
      # @api private
      def convert_hints(el, _indent)
        RPF::Plugin::Kramdown.convert_hints_to_html(el.value)
      end

      # Convert :save -> HTML
      # @api private
      def convert_save(_el, _indent)
        RPF::Plugin::Kramdown.convert_save_to_html
      end

      # Convert :task -> HTML
      # @api private
      def convert_task(el, _indent)
        RPF::Plugin::Kramdown.convert_task_to_html(el.value)
      end
    end

    class Kramdown
      # Convert :challenge -> Markdown (not implemented)
      def convert_challenge(_el, _opts)
        raise NotImplementedError
      end

      # Convert :code -> Markdown (not implemented)
      def convert_code(_el, _opts)
        raise NotImplementedError
      end

      # Convert :collapse -> Markdown (not implemented)
      def convert_collapse(_el, _opts)
        raise NotImplementedError
      end

      # Convert :hint -> Markdown (not implemented)
      def convert_hint(_el, _opts)
        raise NotImplementedError
      end

      # Convert :hints -> Markdown (not implemented)
      def convert_hints(_el, _opts)
        raise NotImplementedError
      end

      # Convert :save -> Markdown (not implemented)
      def convert_save(_el, _opts)
        raise NotImplementedError
      end

      def convert_task(_el, _opts)
        raise NotImplementedError
      end
    end

    class Latex
      # Convert :challenge -> LaTEX (not implemented)
      def convert_challenge(_el, _opts)
        raise NotImplementedError
      end

      # Convert :code -> LaTEX (not implemented)
      def convert_code(_el, _opts)
        raise NotImplementedError
      end

      # Convert :collapse -> LaTEX (not implemented)
      def convert_collapse(_el, _opts)
        raise NotImplementedError
      end

      # Convert :hint -> LaTEX (not implemented)
      def convert_hint(_el, _opts)
        raise NotImplementedError
      end

      # Convert :hints -> LaTEX (not implemented)
      def convert_hints(_el, _opts)
        raise NotImplementedError
      end

      # Convert :save -> LaTEX (not implemented)
      def convert_save(_el, _opts)
        raise NotImplementedError
      end

      # Convert :task -> LaTEX (not implemented)
      def convert_task(_el, _opts)
        raise NotImplementedError
      end
    end
  end

  module Parser
    class KramdownRPF < ::Kramdown::Parser::GFM
      CHALLENGE_PATTERN = %r{^#{OPT_SPACE}---[ \t]*challenge[ \t]*---(.*?)---[ \t]*\/challenge[ \t]*---}m
      CODE_PATTERN      = %r{^#{OPT_SPACE}---[ \t]*code[ \t]*---(.*?)---[ \t]*\/code[ \t]*---}m
      COLLAPSE_PATTERN  = %r{^#{OPT_SPACE}---[ \t]*collapse[ \t]*---(.*?)---[ \t]*\/collapse[ \t]*---}m
      HINT_PATTERN      = %r{^#{OPT_SPACE}---[ \t]*hint[ \t]*---(.*?)---[ \t]*\/hint[ \t]*---}m
      HINTS_PATTERN     = %r{^#{OPT_SPACE}---[ \t]*hints[ \t]*---(.*?)---[ \t]*\/hints[ \t]*---}m
      SAVE_PATTERN      = %r{^#{OPT_SPACE}---[ \t]*save[ \t]*---}m
      TASK_PATTERN      = %r{^#{OPT_SPACE}---[ \t]*task[ \t]*---(.*?)---[ \t]*\/task[ \t]*---}m

      def initialize(source, options)
        super
        @block_parsers.unshift(:challenge)
        @block_parsers.unshift(:code)
        @block_parsers.unshift(:collapse)
        @block_parsers.unshift(:hint)
        @block_parsers.unshift(:hints)
        @block_parsers.unshift(:save)
        @block_parsers.unshift(:task)
      end

      # Convert Markdown -> :challenge
      # @api private
      def parse_challenge
        @src.pos += @src.matched_size
        @tree.children << Element.new(:challenge, @src[1])
      end

      define_parser(:challenge, CHALLENGE_PATTERN)

      # Convert Markdown -> :code
      # @api private
      def parse_code
        @src.pos += @src.matched_size
        @tree.children << Element.new(:code, @src[1])
      end

      define_parser(:code, CODE_PATTERN)

      # Convert Markdown -> :collapse
      # @api private
      def parse_collapse
        @src.pos += @src.matched_size
        @tree.children << Element.new(:collapse, @src[1])
      end

      define_parser(:collapse, COLLAPSE_PATTERN)

      # Convert Markdown -> :hint
      # @api private
      def parse_hint
        @src.pos += @src.matched_size
        @tree.children << Element.new(:hint, @src[1])
      end

      define_parser(:hint, HINT_PATTERN)

      # Convert Markdown -> :hints
      # @api private
      def parse_hints
        @src.pos += @src.matched_size
        @tree.children << Element.new(:hints, @src[1])
      end

      define_parser(:hints, HINTS_PATTERN)

      # Convert Markdown -> :save
      # @api private
      def parse_save
        @src.pos += @src.matched_size
        @tree.children << Element.new(:save, @src[1])
      end

      define_parser(:save, SAVE_PATTERN)

      # Convert Markdown -> :task
      # @api private
      def parse_task
        @src.pos += @src.matched_size
        @tree.children << Element.new(:task, @src[1])
      end

      define_parser(:task, TASK_PATTERN)
    end
  end
end
