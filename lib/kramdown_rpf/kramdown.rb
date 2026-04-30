# frozen_string_literal: true

require 'kramdown'
require 'kramdown/parser/gfm'
require_relative 'rpf'
require_relative 'rfm'

module Kramdown
  module Converter
    class Html
      # Convert :challenge -> HTML
      # @api private
      def convert_challenge(element, _indent)
        RPF::Plugin::Kramdown.convert_challenge_to_html(element.value)
      end

      # Convert :code_filename -> HTML
      # @api private
      def convert_code(element, _indent)
        RPF::Plugin::Kramdown.convert_code_to_html(element.value)
      end

      # Convert :collapse -> HTML
      # @api private
      def convert_collapse(element, _indent)
        RPF::Plugin::Kramdown.convert_collapse_to_html(element.value)
      end

      # Convert :debug -> HTML
      # @api private
      def convert_debug(element, _indent)
        RPF::Plugin::Kramdown.convert_debug_to_html(element.value)
      end

      # Convert :hint -> HTML
      # @api private
      def convert_hint(element, _indent)
        RPF::Plugin::Kramdown.convert_hint_to_html(element.value)
      end

      # Convert :hints -> HTML
      # @api private
      def convert_hints(element, _indent)
        RPF::Plugin::Kramdown.convert_hints_to_html(element.value)
      end

      # Convert :knowledge_quiz_question -> HTML
      # @api private
      def convert_knowledge_quiz_question(element, indent)
        RPF::Plugin::Kramdown.convert_knowledge_quiz_question_to_html(element.value, indent)
      end

      # Convert :new_page -> HTML
      # @api private
      def convert_new_page(*)
        RPF::Plugin::Kramdown.convert_new_page_to_html
      end

      # Convert :no_print -> HTML
      # @api private
      def convert_no_print(element, _indent)
        RPF::Plugin::Kramdown.convert_no_print_to_html(element.value)
      end

      # Convert :print_only -> HTML
      # @api private
      def convert_print_only(element, _indent)
        RPF::Plugin::Kramdown.convert_print_only_to_html(element.value)
      end

      # Convert :quiz -> HTML
      # @api private
      def convert_quiz(element, _indent)
        RPF::Plugin::Kramdown.convert_quiz_to_html(element.value)
      end

      # Convert :save -> HTML
      # @api private
      def convert_save(*)
        RPF::Plugin::Kramdown.convert_save_to_html
      end

      # Convert :task -> HTML
      # @api private
      def convert_task(element, _indent)
        RPF::Plugin::Kramdown.convert_task_to_html(element.value)
      end

      # Convert :tip -> HTML
      # @api private
      def convert_tip(element, _indent)
        RPF::Plugin::Kramdown.convert_tip_to_html(element.value)
      end
    end

    module RaiseNotImplementedForUndefinedConvertMethods
      def method_missing(method_name, *args, &)
        raise NotImplementedError if method_name.to_s.start_with?('convert_')

        super
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?('convert_') || super
      end
    end

    class Kramdown
      include RaiseNotImplementedForUndefinedConvertMethods
    end

    class Latex
      include RaiseNotImplementedForUndefinedConvertMethods
    end
  end

  module Parser
    class KramdownRPF < ::Kramdown::Parser::GFM
      include RFM

      KEYWORDS = %w[
        challenge
        code
        collapse
        hints
        knowledge-quiz-question
        new-page
        no-print
        print-only
        quiz
        save
        task
      ].freeze

      CHALLENGE_PATTERN  = %r{^#{OPT_SPACE}---[ \t]*challenge[ \t]*---(.*?)---[ \t]*/challenge[ \t]*---}m
      CODE_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*code[ \t]*---(.*?)---[ \t]*/code[ \t]*---}m
      COLLAPSE_PATTERN   = %r{^#{OPT_SPACE}---[ \t]*collapse[ \t]*---(.*?)---[ \t]*/collapse[ \t]*---}m
      HINT_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*hint[ \t]*---(.*?)---[ \t]*/hint[ \t]*---}m
      HINTS_PATTERN      = %r{^#{OPT_SPACE}---[ \t]*hints[ \t]*---(.*?)---[ \t]*/hints[ \t]*---}m
      NEW_PAGE_PATTERN   = /^#{OPT_SPACE}---[ \t]*new-page[ \t]*---/m
      NO_PRINT_PATTERN   = %r{^#{OPT_SPACE}---[ \t]*no-print[ \t]*---(.*?)---[ \t]*/no-print[ \t]*---}m
      PRINT_ONLY_PATTERN = %r{^#{OPT_SPACE}---[ \t]*print-only[ \t]*---(.*?)---[ \t]*/print-only[ \t]*---}m
      KNOWLEDGE_QUIZ_QUESTION_PATTERN = %r{^#{OPT_SPACE}---[ \t]*question[ \t]*---(.*?)---[ \t]*/question[ \t]*---}m
      QUIZ_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*quiz[ \t]*---(.*?)---[ \t]*/quiz[ \t]*---}m
      SAVE_PATTERN       = /^#{OPT_SPACE}---[ \t]*save[ \t]*---/m
      TASK_PATTERN       = %r{^#{OPT_SPACE}---[ \t]*task[ \t]*---(.*?)---[ \t]*/task[ \t]*---}m

      def initialize(source, options)
        super
        @block_parsers.unshift(:challenge)
        @block_parsers.unshift(:code)
        @block_parsers.unshift(:collapse)
        @block_parsers.unshift(:hint)
        @block_parsers.unshift(:hints)
        @block_parsers.unshift(:knowledge_quiz_question)
        @block_parsers.unshift(:new_page)
        @block_parsers.unshift(:no_print)
        @block_parsers.unshift(:print_only)
        @block_parsers.unshift(:quiz)
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

      # Convert Markdown -> :knowledge_quiz_question
      # @api private
      def parse_knowledge_quiz_question
        @src.pos += @src.matched_size
        @tree.children << Element.new(:knowledge_quiz_question, @src[1])
      end

      define_parser(:knowledge_quiz_question, KNOWLEDGE_QUIZ_QUESTION_PATTERN)

      # Convert Markdown -> :new_page
      # @api private
      def parse_new_page
        @src.pos += @src.matched_size
        @tree.children << Element.new(:new_page, @src[1])
      end

      define_parser(:new_page, NEW_PAGE_PATTERN)

      # Convert Markdown -> :no_print
      # @api private
      def parse_no_print
        @src.pos += @src.matched_size
        @tree.children << Element.new(:no_print, @src[1])
      end

      define_parser(:no_print, NO_PRINT_PATTERN)

      # Convert Markdown -> :print_only
      # @api private
      def parse_print_only
        @src.pos += @src.matched_size
        @tree.children << Element.new(:print_only, @src[1])
      end

      define_parser(:print_only, PRINT_ONLY_PATTERN)

      # Convert Markdown -> :quiz
      # @api private
      def parse_quiz
        @src.pos += @src.matched_size
        @tree.children << Element.new(:quiz, @src[1])
      end

      define_parser(:quiz, QUIZ_PATTERN)

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

  class ParseError < RuntimeError; end

  class Document
    def to_html
      output, warnings = Kramdown::Converter::Html.convert(@root, @options)
      @warnings.concat(warnings)
      validate!(output)
    end

    private

    def validate!(output)
      keywords = ::Kramdown::Parser::KramdownRPF::KEYWORDS
      invalid = keywords.select { |keyword| output =~ Regexp.new("—[\s]*#{keyword}[\s]*—") }
      raise ParseError, "Markdown contained an unclosed tag: #{invalid}" unless invalid.empty?

      output
    end
  end
end
